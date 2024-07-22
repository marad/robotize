export 'package:robotize/src/window.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';

import 'dart:async';
import 'dart:ffi';
import 'package:event_bus/event_bus.dart';
import 'package:ffi/ffi.dart';
import 'package:robotize/src/winapi.dart' as winapi;
import 'package:robotize/src/window.dart';

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

/// 
/// Function that starts the windows loop isolate
/// 
Future<void> start(EventBus eventBus) {
  var msg = allocate<winapi.MSG>();

  eventBus.on<RegisterHotkey>().listen((event) {
    RegisterHotkey data = event;
    var result = winapi.RegisterHotKey(nullptr, data.hotkeyId, data.modifiers, data.keyCode);
    if (result == 0) {
      print("Error registering hotkey!");
      var error = winapi.GetLastError();
      print('Error: $error');
    } else {
      print("Hotkey $data registered");
    }
  });

  eventBus.on<UnregisterHotkey>().listen((event) {
    UnregisterHotkey data = event;
    winapi.UnregisterHotKey(nullptr, data.hotkeyId);
  });

  initWindowMonitor(eventBus);
  return scheduleWindowsMessageProcessing(msg, eventBus);
}

Future<Void> scheduleWindowsMessageProcessing(Pointer<winapi.MSG> msg, EventBus eventBus) async =>
  Future.delayed(Duration(milliseconds: 10), () {
    try {
      var result = winapi.PeekMessageW(msg, nullptr, 0, 0, winapi.PM_REMOVE);
      if (result != 0) {
          if (msg.ref.message == winapi.WM_HOTKEY) {
            print('Hotkey pressed!');
            eventBus.fire(HotkeyPressed(msg.ref.wParam.address));
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
    scheduleWindowsMessageProcessing(msg, eventBus);
    return;
  });



//================================================================================
// Active window monitoring
//================================================================================

var _windowMonitorEventBus = EventBus(sync: true);
void initWindowMonitor(EventBus eventBus) {
  _windowMonitorEventBus = eventBus;
  var func = Pointer.fromFunction<winapi.WinEventHookCallback>(_windowChangedCallback);
  winapi.SetWinEventHook(
    winapi.EVENT_SYSTEM_FOREGROUND,
    winapi.EVENT_SYSTEM_FOREGROUND,
    nullptr,
    func,
    0, 0,
    winapi.WINEVENT_OUTOFCONTEXT | winapi.WINEVENT_SKIPOWNPROCESS);

  winapi.SetWinEventHook(
    winapi.EVENT_OBJECT_CREATE,
    winapi.EVENT_OBJECT_CREATE,
    nullptr,
    func,
    0, 0,
    winapi.WINEVENT_OUTOFCONTEXT | winapi.WINEVENT_SKIPOWNPROCESS);

  // var shellFunc = Pointer.fromFunction<winapi.ShellProc>(_shellCallback, 0);
  // winapi.SetWindowsHookExW(winapi.WH_SHELL, shellFunc, nullptr, 0);
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
  if (event == winapi.EVENT_SYSTEM_FOREGROUND) {
    _windowMonitorEventBus.fire(WindowChanged(window));
  } else if (event == winapi.EVENT_OBJECT_CREATE) {
    print('Window created: ${window.getWindowInfo()}');
  } else if (event == winapi.EVENT_OBJECT_DESTROY) {
    print('Window destroyed ${window.getWindowText()}');
  }
}

int _shellCallback(int code, Pointer<Uint64> wParam, Pointer<Int64> lParam) {
  if (code == winapi.HSHELL_WINDOWCREATED) {
    print('Window created');
  } else if(code == winapi.HSHELL_WINDOWDESTROYED) {
    print('Window destroyed');
  }
  print('callback');
  return winapi.CallNextHookEx(nullptr, code, wParam, lParam);
}