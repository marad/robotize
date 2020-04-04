import 'dart:ffi';
import 'dart:io';

import 'winapi.dart' as winapi;
import 'keyboard.dart';

class Input {
  var keyPressDuration = Duration(milliseconds: 20);
  void send(String toSend, {raw: false}) {
    sendKeys(Keyboard.decodeEvents(toSend, raw: raw));
  }

  void sendKeys(List<KeyEvent> keyEvents) {
    // TODO: 
    // - save pressed keys
    // - unset pressed keys
    keyEvents.forEach((event) {
      event.modifiers.forEach((name) => sendKeyDown(keyMap[name]));
      if (event.down) {
        sendKeyDown(event.keyCode);
      }

      sleep(keyPressDuration);

      if (event.up) {
        sendKeyUp(event.keyCode);
      }
      event.modifiers.forEach((name) => sendKeyUp(keyMap[name]));
    });
    // - set previously pressed keys
  }

  void sendKeyDown(int virtualKeyCode) {
    var event = winapi.KeyboardInput.allocate(virtualKeyCode: virtualKeyCode);
    winapi.SendInput(1, event.addressOf, sizeOf<winapi.KeyboardInput>());
  }

  void sendKeyUp(int virtualKeyCode) {
    var event = winapi.KeyboardInput.allocate(
      virtualKeyCode: virtualKeyCode, 
      flags: winapi.KEYEVENTF_KEYUP);
    winapi.SendInput(1, event.addressOf, sizeOf<winapi.KeyboardInput>());
  }
}
