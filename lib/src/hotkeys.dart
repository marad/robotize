import 'dart:ffi';
import 'package:event_bus/event_bus.dart';
import 'package:robotize/src/keyboard.dart';

import 'winapi.dart' as winapi;

class HotkeyPressed {
  final int hotkeyId;
  HotkeyPressed(this.hotkeyId);
}

class Hotkey {
  final EventBus _eventBus;
  var _hotkeyIds = <String, int>{};
  var _hotkeys = <int, Function>{};
  var _nextId = 0;

  Hotkey(this._eventBus) {
    _eventBus.on<HotkeyPressed>()
      .listen((hkPressed) {
         _hotkeys[hkPressed.hotkeyId]();
      });
  }

  operator []=(String hk, Function callback) => add(hk, callback);

  void add(String hotkey, Function callback) {
    var key = Keyboard.decodeEvents(hotkey).single;
    var hotkeyId = _nextId++;
    _hotkeyIds[hotkey] = hotkeyId;
    _hotkeys[hotkeyId] = callback;
    // TODO add modifiers
    winapi.RegisterHotKey(nullptr, hotkeyId, 0, key.keyCode);
  }

  void remove(String hotkey) {
    var hotkeyId = _hotkeyIds[hotkey];
    _hotkeys.remove(hotkeyId);
    _hotkeyIds.remove(hotkey);
    winapi.UnregisterHotKey(nullptr, hotkeyId);
  }
}
