import 'package:robotize/src/keyboard.dart';
import 'package:robotize/src/keystring.dart';
import 'package:test/test.dart';

void main() {
  test("decode simple key press", () {
    expect(decodeKeysFromTokens(["s"]), <KeyEvent>[KeyEvent("s", keyMap["S"])]);
  });

  test("decode modified key press", () {
    expect(decodeKeysFromTokens(["+", "s"]), <KeyEvent>[KeyEvent("s", keyMap["S"], shift: true)]);
    expect(decodeKeysFromTokens(["+", "!", "s"]), <KeyEvent>[KeyEvent("s", keyMap["S"], shift: true, alt: true)]);
    expect(decodeKeysFromTokens(["!", "+", "s"]), <KeyEvent>[KeyEvent("s", keyMap["S"], shift: true, alt: true)]);
    expect(decodeKeysFromTokens(["^", "s"]), <KeyEvent>[KeyEvent("s", keyMap["S"], ctrl: true)]);
    expect(decodeKeysFromTokens(["#", "s"]), <KeyEvent>[KeyEvent("s", keyMap["S"], win: true)]);
  });


  test("decode formatted key press", () {
    expect(
      decodeKeysFromTokens(["{", "F12", "}"]),
      <KeyEvent>[KeyEvent("F12", keyMap["F12"])]
    );

    expect(
      decodeKeysFromTokens(["{", "F12", "down", "}"]),
      <KeyEvent>[KeyEvent("F12", keyMap["F12"], down: true, up: false)]
    );

    expect(
      decodeKeysFromTokens(["{", "F12", "up", "}"]),
      <KeyEvent>[KeyEvent("F12", keyMap["F12"], down: false, up: true)]
    );

    expect(
      decodeKeysFromTokens(["+", "{", "F12", "up", "}"]),
      <KeyEvent>[KeyEvent("F12", keyMap["F12"], down: false, up: true, shift: true)]
    );
  });

  test("decode lower case named special key", () {
    expect(
      decodeKeysFromTokens(["{", "ctrl", "}"]),
      <KeyEvent>[KeyEvent("ctrl", keyMap["CTRL"])]
    );
  });

  test("decode complex expression", () {
    expect(
      decodeKeysFromTokens(["^", "{", "ESCAPE", "}", "+", "{", "F12", "down", "}", "s", "{", "F12", "up", "}"]),
      <KeyEvent>[
        KeyEvent("ESCAPE", keyMap["ESCAPE"], ctrl: true),
        KeyEvent("F12", keyMap["F12"], down: true, up: false, shift: true),
        KeyEvent("s", keyMap["S"]),
        KeyEvent("F12", keyMap["F12"], down: false, up: true),
        ]
    );

    expect(
      decode("^{ESCAPE}+{F12 down}s{F12 up}"),
      <KeyEvent>[
        KeyEvent("ESCAPE", keyMap["ESCAPE"], ctrl: true),
        KeyEvent("F12", keyMap["F12"], down: true, up: false, shift: true),
        KeyEvent("s", keyMap["S"]),
        KeyEvent("F12", keyMap["F12"], down: false, up: true),
        ]
    );
  });

  test("decode braces", () {
    expect( 
      decodeKeysFromTokens(["{", "{", "}"]),
      <KeyEvent>[
        KeyEvent("{", keyMap["["], shift: true),
        // KeyEvent("}", keyMap["]"], shift: true)
      ]
    );

    expect( 
      decodeKeysFromTokens(["{", "}", "}"]),
      <KeyEvent>[
        KeyEvent("}", keyMap["]"], shift: true),
        // KeyEvent("}", keyMap["]"], shift: true)
      ]
    );
  });
}