import 'package:robotize/src/keyboard.dart';
import 'package:test/test.dart';

void main() {
  group("simple letters", () {
    var upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUWXYZ";
    var lowerCaseLetters = "abcdefghijklmnopqrstuwxyz";


    for(var index=0; index < upperCaseLetters.length; index++) {
        var letter = upperCaseLetters[index];
        test("should parse upper-case letter: '$letter'", () {
            var key = Keyboard.decodeEvents(letter, raw: true).first;

            expect(key.char, letter);
            expect(key.keyCode, keyMap[letter]);
            expect(key.shift, true);
            expect(key.alt, false);
            expect(key.ctrl, false);
            expect(key.down, true);
            expect(key.up, true);
        });

    }

    for(var index=0; index < lowerCaseLetters.length; index++) {
        var letter = lowerCaseLetters[index];
        test("should parse lower-case letter: '$letter'", () {
            var key = Keyboard.decodeEvents(letter, raw: true).first;

            expect(key.char, letter);
            expect(key.keyCode, keyMap[letter.toUpperCase()]);
            expect(key.shift, false);
            expect(key.alt, false);
            expect(key.ctrl, false);
            expect(key.down, true);
            expect(key.up, true);
        });
    }
  });

  group("should parse no shift special character: ", () {
    var characters = [
      ["`", 0xC0],
      ["-", 0xBD],
      ["=", 0xBB],
      ["[", 0xDB],
      ["]", 0xDD],
      [";", 0xBA],
      ["'", 0xDE],
      ["\\", 0xDC],
      ["/", 0x6F],
      [",", 0xBC],
      [".", 0xBE],
    ];

    for(var index=0; index < characters.length; index++) {
      var char = characters[index].first;
      var expectedVkey = characters[index].last;
      test(char, () {
        var key = Keyboard.decodeEvents(char, raw: true).first;

        expect(key.char, char);
        expect(key.keyCode, expectedVkey);
        expect(key.up, true);
        expect(key.down, true);
        expect(key.shift, false);
        expect(key.ctrl, false);
        expect(key.alt, false);
      });
    }
  });

  group("should parse shifted special character: ", () {
    var characters = [
      ["~", 0xC0],
      ["!", 0x31],
      ["@", 0x32],
      ["#", 0x33],
      ["\$", 0x34],
      ["%", 0x35],
      ["^", 0x36],
      ["&", 0x37],
      ["*", 0x38],
      ["(", 0x39],
      [")", 0x30],
      ["_", 0xBD],
      ["+", 0xBB],
      ["{", 0xDB],
      ["}", 0xDD],
      ["|", 0xDC],
      [":", 0xBA],
      ["\"", 0xDE],
      ["<", 0xBC],
      [">", 0xBE],
      ["?", 0x6F],
    ];

    for(var index=0; index < characters.length; index++) {
      var char = characters[index].first;
      var expectedVkey = characters[index].last;
      test(char, () {
        var key = Keyboard.decodeEvents(char, raw: true).first;

        expect(key.char, char);
        expect(key.keyCode, expectedVkey);
        expect(key.up, true);
        expect(key.down, true);
        expect(key.shift, true);
        expect(key.ctrl, false);
        expect(key.alt, false);
      });
    }
  });
}