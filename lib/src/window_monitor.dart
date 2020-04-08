import 'dart:ffi';

import 'package:event_bus/event_bus.dart';
import 'package:robotize/robotize.dart';
import 'package:robotize/src/winapi.dart' as winapi;


EventBus _eventBus;
Pointer _eventHook;

void initWindowMonitor(EventBus eventBus) {
  _eventBus = eventBus;
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
  _eventBus.fire(WindowChanged(window));
}

class WindowChanged {
  final Window newWindow;
  WindowChanged(this.newWindow);
}