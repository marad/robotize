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
  }

  void sendKeyDown(int virtualKeyCode) {
    winapi.keybd_event(
        virtualKeyCode,
        winapi.MapVirtualKeyW(virtualKeyCode, winapi.MAPVK_VK_TO_VSC),
        winapi.KEYEVENTF_EXTENDEDKEY,
        nullptr);
  }

  void sendKeyUp(int virtualKeyCode) {
    winapi.keybd_event(
        virtualKeyCode,
        winapi.MapVirtualKeyW(virtualKeyCode, winapi.MAPVK_VK_TO_VSC),
        winapi.KEYEVENTF_EXTENDEDKEY | winapi.KEYEVENTF_KEYUP,
        nullptr);
  }
}
