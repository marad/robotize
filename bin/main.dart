
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:robotize/robotize.dart';
import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/winapi.dart' as winapi;

main() {
  robotizeInit();
  // print('Current window:');
  // var id = getActiveWindow();
  // print(id.asPointer().address);
  // print(getWindowText(id));
  // print(getWindowInfo(id));
  var active = Windows.getActiveWindow();
  print(active.getWindowText());

  // print('All windows:');
  // var windows = listWindows();
  // print('Found ${windows.length} windows!');
  // var allWindows = windows.list();
  // for(var window in allWindows) {
    // print(window.getWindowText());
  // }

  // print('Switch to "YakYak"');
  // var window = findWindow(WindowQuery(titleMatcher: "YakYak"));
  // // activateWindow(window.id);

  // var viewer = findWindow(WindowQuery(titleMatcher: "DLL Export Viewer"));
  // activateWindow(viewer.id);
  // print(quitWindow(viewer.id));

  // var notepad = findWindow(WindowQuery(titleMatcher: "WindowsProject1"));
  // var notepad = findWindow(WindowQuery(titleMatcher: "Firefox"));
  // var notepad = findWindow(WindowQuery(titleMatcher: "Notatnik"));
  // activateWindow(notepad.id);
  // sleep(Duration(milliseconds: 1000));
  // sendKey(notepad.id, "hello".codeUnitAt(0));

  // var notepad = findWindow(WindowQuery(titleMatcher: "Notepad"));
  // print('Activating window');
  // activateWindow(notepad.id);
  // print('Writing...');
  // sleep(Duration(milliseconds: 500));

  // sendInput("Hello World!");
  // quitWindow(notepad.id);


  hotkey.add("{F4}", () {
    // var currentState = allocate<Int8>(count: 256);
    // winapi.GetKeyboardState(currentState);


    // String getKeyName(int a) {
    //   var entries = keyMap.entries.where((entry) => entry.value == a);
    //   if (entries.length > 0) {
    //     return entries.first.key;
    //   } else {
    //     return "$a";
    //   }
    // }

    // var clearedState = allocate<Int8>(count: 256);
    // for(var i = 0; i < 256; i++) {
    //   print('${getKeyName(i)}: ${currentState.elementAt(i).value}');
    //   var value = currentState.elementAt(i).value;
    //   if (vkeysToClear.contains(value)) {
    //     clearedState.elementAt(i).value = 0;
    //   } else {
    //     clearedState.elementAt(i).value = value;
    //   }
    // }
    // winapi.SetKeyboardState(clearedState);

    ////////////////////////////////////////////////////////////////////////////////
    
    // var window = windows.getActiveWindow();
    // var sc = winapi.MapVirtualKeyW(0xA0, winapi.MAPVK_VK_TO_VSC);
    // winapi.PostMessageW(
    //   window.getWindowInfo().id.asPointer(),
    //   0x0101, // WM_KEYUP
    //   Pointer.fromAddress(0xA0),
    //   Pointer.fromAddress((sc << 16) | 0xC0000001)
    // );

    // input.sendKeyUp(0x11);
    // input.sendKeyUp(0xA2);
    // input.sendKeyUp(0xA3);

    // clipboard.text = "This is sparta! 😀";
    // var desktop = Window(WindowId.fromPointer(winapi.GetDesktopWindow()));
    // input.click(500, 500, button: MouseButton.Left, clickMode: ClickMode.RelativeToWindowClientArea);
    var window = Windows.find(WindowQuery(titleMatcher: "Untitled"));
    print(window.getWindowText());
    // var window = Windows.getActiveWindow();
    print(window.isAlwaysOnTop());
    window.setAlwaysOnTop(!window.isAlwaysOnTop());
    print('Window set to always on top');
    // input.send("^v");
    // input.send("Hello Wor{SHIFT down}ld{SHIFT up}{ENTER}");
    // input.send("{{}{}}"); // czemu to nie dziala?

    // var eventDown = winapi.KeyboardInput.allocate(virtualKeyCode: 9925, flags: winapi.KEYEVENTF_UNICODE);
    // var eventDown = winapi.KeyboardInput.allocate(0, '😀'.codeUnitAt(0), winapi.KEYEVENTF_UNICODE);
    // var eventUp = winapi.KeyboardInput.allocate(0, '😀'.codeUnitAt(0), winapi.KEYEVENTF_UNICODE | winapi.KEYEVENTF_KEYUP);

    // winapi.SendInput(1, eventDown.addressOf, sizeOf<winapi.KeyboardInput>());
    // winapi.SendInput(1, eventUp.addressOf, sizeOf<winapi.KeyboardInput>());


    // winapi.SetKeyboardState(currentState);
    // if (shiftDown != 0) {
    //   input.send("{SHIFT down}");
    // }
  });

  robotizeMainLoop();
}