export 'package:robotize/src/window.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';


import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:robotize/src/clipboard.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/winapi_main.dart' as winapi_main;
import 'package:robotize/src/hotkeys.dart';
import 'package:robotize/src/input.dart';
import 'package:robotize/src/window.dart';

var _eventBus = EventBus();
Input input = null;
Hotkey hotkey = null;
Clipboard clipboard = null;
Windows windows = null;

//Hotstr hotstr = null;

void robotizeInit() {
  input = Input();
  hotkey = Hotkey(_eventBus);
  windows = Windows(_eventBus);
  clipboard = Clipboard();
  Keyboard.init(_eventBus);

  winapi_main.start(_eventBus);
  _eventBus.on<winapi_main.WindowChanged>().listen((event) {
    print("Window changed ${event.newWindow.getWindowText()}");
  });
}