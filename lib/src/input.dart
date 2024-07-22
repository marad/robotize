import 'dart:ffi';
import 'dart:io';

import 'package:robotize/robotize.dart';

import 'models.dart';
import 'winapi.dart' as winapi;
import 'keyboard.dart';

class Input {
  var keyPressDuration = Duration(milliseconds: 20);

  void click(int x, int y, {MouseButton button = MouseButton.Left, ClickMode clickMode = ClickMode.Absolute}) {
    final desktopWindowRect = windows.getDesktopWindow().getWindowRect();

    var pixelX = null;
    var pixelY = null;

    switch (clickMode) {
      case ClickMode.RelativeToWindow:
        final activeWindowRect = windows.getActiveWindow().getWindowRect();
        pixelX = activeWindowRect.left + x;
        pixelY = activeWindowRect.top + y;
        break;
      case ClickMode.RelativeToWindowClientArea:
        var clientOrigin = windows.getActiveWindow().clientToScreen(Point(x: 0, y: 0));
        pixelX = clientOrigin.x + x;
        pixelY = clientOrigin.y + y;
        break;
      case ClickMode.Absolute:
      default:
        pixelX = x;
        pixelY = y;
    }

    final int absoluteX = (pixelX.toDouble() * 65535.0 / desktopWindowRect.width.toDouble()).toInt();
    final int absoluteY = (pixelY.toDouble() * 65535.0 / desktopWindowRect.height.toDouble()).toInt();

    var eventDown = winapi.MouseInput.allocate(
      absoluteX, absoluteY, 
      flags: winapi.MOUSEEVENTF_MOVE | winapi.MOUSEEVENTF_ABSOLUTE | _mouseButtonFlags(button));
    winapi.SendInput(1, eventDown.addressOf, sizeOf<winapi.MouseInput>());
  }

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


enum ClickMode {
  Absolute, RelativeToWindow, RelativeToWindowClientArea
}

enum MouseButton {
  Left, LeftDown, LeftUp,
  Right, RightDown, RightUp,
  Middle, MiddleDown, MiddleUp
}

int _mouseButtonFlags(MouseButton button) {
  switch (button) {
    case MouseButton.Left: return winapi.MOUSEEVENTF_LEFTDOWN | winapi.MOUSEEVENTF_LEFTUP;
    case MouseButton.LeftDown: return winapi.MOUSEEVENTF_LEFTDOWN;
    case MouseButton.LeftUp: return winapi.MOUSEEVENTF_LEFTUP;

    case MouseButton.Right: return winapi.MOUSEEVENTF_RIGHTDOWN | winapi.MOUSEEVENTF_RIGHTUP;
    case MouseButton.RightDown: return winapi.MOUSEEVENTF_RIGHTDOWN;
    case MouseButton.RightUp: return winapi.MOUSEEVENTF_RIGHTUP;

    case MouseButton.Middle: return winapi.MOUSEEVENTF_MIDDLEDOWN | winapi.MOUSEEVENTF_MIDDLEUP;
    case MouseButton.MiddleDown: return winapi.MOUSEEVENTF_MIDDLEDOWN;
    case MouseButton.MiddleUp: return winapi.MOUSEEVENTF_MIDDLEUP;

    default: return 0;
  }
}