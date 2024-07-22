import 'package:robotize/robotize.dart';

main() async {
  robotizeInit();

  hotkey.add("{F3}", () {
    var window = windows.getActiveWindow();
    print(window.getExeName());
  });

  hotkey.add("{F4}", () {
    var window = windows.find(WindowQuery(titleMatcher: "Notepad"));
    window.activateWindow();
    print(window.getExeName());
  });

  await windows.waitActive(WindowQuery(titleMatcher: "Notepad"));

  print('Notepad active');

  await windows.waitInactive(WindowQuery(titleMatcher: "Notepad"));

  print('Notepad not active');
}