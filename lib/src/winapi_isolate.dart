export 'package:robotize/src/windows.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';

import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'package:event_bus/event_bus.dart';
import 'package:ffi/ffi.dart';
import 'package:robotize/src/winapi.dart' as winapi;
import 'package:robotize/src/windows.dart';

abstract class EgressEvent {}
abstract class IngressEvent {}

//================================================================================
// Events for communication
//================================================================================
class RegisterHotkey extends IngressEvent {
  RegisterHotkey(this.keyCode, this.hotkeyId, this.modifiers);
  final int keyCode;
  final int hotkeyId;
  final int modifiers;
}

class UnregisterHotkey extends IngressEvent {
  UnregisterHotkey(this.hotkeyId);
  final int hotkeyId;
}

class HotkeyPressed extends EgressEvent {
  HotkeyPressed(this.hotkeyId);
  final int hotkeyId;
}

class WindowChanged extends EgressEvent {
  WindowChanged(this.newWindow);
  final Window newWindow;
}

//================================================================================

Isolate _winapi_isolate;
Pointer _eventHook;

//================================================================================

/// 
/// Function that starts the windows loop isolate
/// 
Future<SendPort> start(EventBus eventBus) async {
  final receivePort = ReceivePort();
  final completer = Completer<SendPort>();

  receivePort.listen((event) {
    if (event is SendPort) {
      completer.complete(event);
    } else if (event is EgressEvent) {
      eventBus.fire(event);
    } else {
      print('Unknown event from main loop: $event');
    }
  });

  _winapi_isolate = await Isolate.spawn(_robotizeMainLoop, receivePort.sendPort);
  return completer.future;
}

///
/// Main function for isolate running windows main loop
/// 
void _robotizeMainLoop(SendPort sendPort) {
  var receivePort = ReceivePort();
  var msg = allocate<winapi.MSG>();

  receivePort.listen((event) {
    if (event is RegisterHotkey) {
      RegisterHotkey data = event;
      var result = winapi.RegisterHotKey(nullptr, data.hotkeyId, data.modifiers, data.keyCode);
      if (result == 0) {
        print("Error registering hotkey!");
        var error = winapi.GetLastError();
        print('Error: $error');
      } else {
        print("Hotkey $data registered");
      }
    } else if (event is UnregisterHotkey) {
      UnregisterHotkey data = event;
      winapi.UnregisterHotKey(nullptr, data.hotkeyId);
    } else {
      print('Winapi isolate received unhandled event: $event');
    }
  });

  sendPort.send(receivePort.sendPort);
  initWindowMonitor(sendPort);
  scheduleWindowsMessageProcessing(msg, sendPort);
}

Future<Void> scheduleWindowsMessageProcessing(Pointer<winapi.MSG> msg, SendPort sendPort) async =>
  Future.delayed(Duration(milliseconds: 10), () {
    try {
      var result = winapi.PeekMessageW(msg, nullptr, 0, 0, winapi.PM_REMOVE);
      if (result != 0) {
          if (msg.ref.message == winapi.WM_HOTKEY) {
            print('Hotkey pressed!');
            sendPort.send(HotkeyPressed(msg.ref.wParam.address));
          } else {
            winapi.TranslateMessage(msg);
            winapi.DispatchMessage(msg);
          }
      }
    } on NoSuchMethodError {
      // I have no idea why, but invoking callback set with SetWinEventHook 
      // from window monitor causes this error. This is a nasty workaround,
      // because callback is clearly fired.
    }
    scheduleWindowsMessageProcessing(msg, sendPort);
    return;
  });



//================================================================================
// Active window monitoring
//================================================================================

final _windowMonitorEventBus = EventBus(sync: true);
void initWindowMonitor(SendPort sendPort) {
  _windowMonitorEventBus.on().listen(sendPort.send);
  var func = Pointer.fromFunction<winapi.WinEventHookCallback>(_windowChangedCallback);
  _eventHook = winapi.SetWinEventHook(
    winapi.EVENT_SYSTEM_FOREGROUND,
    winapi.EVENT_SYSTEM_FOREGROUND,
    nullptr,
    func,
    0, 0,
    winapi.WINEVENT_OUTOFCONTEXT | winapi.WINEVENT_SKIPOWNPROCESS);
}

void _windowChangedCallback(
  Pointer eventHook,
  int event, 
  Pointer hwnd,
  int idObject,
  int idChild,
  int eventThread,
  int eventTime,
) {
  var window = Window(WindowId.fromPointer(hwnd));
  _windowMonitorEventBus.fire(WindowChanged(window));
}
