import 'package:event_bus/event_bus.dart';

import 'package:robotize/robotize.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/winapi_main.dart';

import 'winapi.dart' as winapi;

class HotkeyDetails {
  HotkeyDetails(this.hotkeyString, this.keyEvent, this.callback);
  final String hotkeyString;
  final KeyEvent keyEvent;
  final Function callback;
}

class Hotkey {
  final EventBus _eventBus;
  var _hotkeyIds = <String, int>{};
  var _hotkeys = <int, HotkeyDetails>{};
  var _nextId = 1;

  Hotkey(this._eventBus) {
    _eventBus.on<HotkeyPressed>()
      .listen((hkPressed) {
        try {
          var hkDetails = _hotkeys[hkPressed.hotkeyId];
          hkDetails.keyEvent
            .modifiers.forEach((modifier) => input.sendKeyUp(keyMap[modifier]));
          hkDetails.callback();
          hkDetails.keyEvent
            .modifiers.forEach((modifier) => input.sendKeyDown(keyMap[modifier]));
        }
        catch(e) {
          print("Some exception: ${e}");
        }
      });
  }

  operator []=(String hk, Function callback) => add(hk, callback);

  void add(String hotkey, Function callback) {
    var key = Keyboard.decodeEvents(hotkey).single;
    var hotkeyId = _nextId++;
    _hotkeyIds[hotkey] = hotkeyId;
    _hotkeys[hotkeyId] = HotkeyDetails(hotkey, key, callback);
    var modifiers = 0;
    if (key.shift) {
      modifiers |= winapi.MOD_SHIFT;
    }
    if (key.ctrl) {
      modifiers |= winapi.MOD_CONTROL;
    }
    if (key.alt) {
      modifiers |= winapi.MOD_ALT;
    }
    if (key.win) {
      modifiers |= winapi.MOD_WIN;
    }
    _eventBus.fire(RegisterHotkey(key.keyCode, hotkeyId, modifiers));
  }

  void remove(String hotkey) {
    var hotkeyId = _hotkeyIds[hotkey];
    _hotkeys.remove(hotkeyId);
    _hotkeyIds.remove(hotkey);
    _eventBus.fire(UnregisterHotkey(hotkeyId));
  }
}
