export 'package:robotize/src/windows.dart';
export 'package:robotize/src/input.dart';
export 'package:robotize/src/hotkeys.dart';


import 'package:event_bus/event_bus.dart';
import 'package:robotize/src/clipboard.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/winapi_isolate.dart' as winapi_isolate;
import 'package:robotize/src/hotkeys.dart';
import 'package:robotize/src/input.dart';

var _eventBus = EventBus();
Input input = null;
Hotkey hotkey = null;
Clipboard clipboard = null;

//Hotstr hotstr = null;

void robotizeInit() async {
  input = Input();
  hotkey = Hotkey(_eventBus);
  clipboard = Clipboard();
  Keyboard.init(_eventBus);

  var sendPort = await winapi_isolate.start(_eventBus);
  _eventBus.on<winapi_isolate.WindowChanged>().listen((event) {
    print("Window changed ${event.newWindow.getWindowText()}");
  });

  void sendToIsolate(event) { 
    if (event is winapi_isolate.IngressEvent) sendPort.send(event);
  }
  _eventBus.on().listen(sendToIsolate);
}
