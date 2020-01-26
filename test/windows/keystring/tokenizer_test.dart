import 'package:test/test.dart';
import 'package:robotize/src/keystring.dart';

void main() {
  test("simple tokenization", () {
    expect(tokenizeKeystring("#a+b!c^d"), ["#", "a", "+", "b", "!", "c", "^", "d"]);
  });

  test("named key format tokenization", () {
    expect(tokenizeKeystring("{F12}"), ["{", "F12", "}"]);
    expect(tokenizeKeystring("{ENTER}"), ["{", "ENTER", "}"]);
    expect(tokenizeKeystring("{{}"), ["{", "{", "}"]);
    expect(tokenizeKeystring("{}}"), ["{", "}", "}"]);
    expect(tokenizeKeystring("{} down}"), ["{", "}", "down", "}"]);
  });

  test("named key with argument tokenization", () {
    expect(tokenizeKeystring("{F12 down}"), ["{", "F12", "down", "}"]);
  });

  test("complex expression", () {
    expect(
      tokenizeKeystring("+{F10 down}s{F10 up}"),
      ["+", "{", "F10", "down", "}", "s", "{", "F10", "up", "}"]);
  });
}