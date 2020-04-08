export 'package:robotize/src/windows.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';

import 'dart:ffi';
import 'package:event_bus/event_bus.dart';
import 'package:ffi/ffi.dart';
import 'package:robotize/src/clipboard.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/window_monitor.dart';
import 'package:robotize/src/hotkeys.dart';
import 'package:robotize/src/input.dart';
import 'package:robotize/src/winapi.dart' as winapi;

var _eventBus = EventBus(sync: true);
Input input = null;
Hotkey hotkey = null;
Clipboard clipboard = null;
//Hotstr hotstr = null;

void robotizeInit() {
  input = Input();
  hotkey = Hotkey(_eventBus);
  initWindowMonitor(_eventBus);
  clipboard = Clipboard();
  Keyboard.init(_eventBus);

  _eventBus.on<WindowChanged>().listen((event) {
    print("Window changed ${event.newWindow.getWindowText()}");
  });
}

void robotizeMainLoop() {

  var msg = allocate<winapi.MSG>();

  while(true) { 
    try {
      var result = winapi.GetMessage(msg, nullptr, 0, 0);
      if (result > 0) {

        if (msg.ref.message == winapi.WM_HOTKEY) {
          _eventBus.fire(HotkeyPressed(msg.ref.wParam.address));
        } else {
          winapi.TranslateMessage(msg);
          winapi.DispatchMessage(msg);
        }


      } else if (result < 0) {
        // TODO: error handling
        print('Some error!');
      } else if (result == 0) {
        // TODO: cleanup hooks
        print('Some error!');
        break;
      }
    } on NoSuchMethodError {
      // I have no idea why, but invoking callback set with SetWinEventHook 
      // from window monitor causes this error. This is a nasty workaround,
      // because callback is clearly fired.
      continue;
    }

  }
}