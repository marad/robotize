import 'package:robotize/robotize.dart';

main() {
  robotizeInit();
  hotkey.add("{F3}", () {
    var window = Windows.getActiveWindow();
    print(window.getExeName());
  });

  hotkey.add("{F4}", () {
    var window = Windows.find(WindowQuery(titleMatcher: "Notepad"));
    print(window.getExeName());
  });

  robotizeMainLoop();
}