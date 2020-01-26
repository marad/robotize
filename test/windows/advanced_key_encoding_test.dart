import 'package:test/test.dart';
import 'package:robotize/src/keyboard.dart';

void main() {
  test("named key encoding", () {
    var namedKeys = ["ENTER", "F1", "HOME"];

    for(var keyName in namedKeys) {
      var events = Keyboard.decodeEvents("{$keyName}");
      // expect(events.length, 1);
      // expect(events.first.keyCode, keyMap[keyName]);
    }
  });
}