export 'package:robotize/src/windows.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';

import 'dart:ffi';
import 'package:event_bus/event_bus.dart';
import 'package:ffi/ffi.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/windows.dart';
import 'package:robotize/src/hotkeys.dart';
import 'package:robotize/src/input.dart';
import 'package:robotize/src/winapi.dart' as winapi;

var _eventBus = EventBus(sync: true);
Input input = null;
Windows windows = null;
Hotkey hotkey = null;
//Hotstr hotstr = null;

void roboInit() {
  input = Input();
  windows = Windows();
  hotkey = Hotkey(_eventBus);
  Keyboard.init(_eventBus);
}

void roboMainLoop() {

  var msg = allocate<winapi.MSG>();

  while(true) { 
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
      break;
    }
  }
}