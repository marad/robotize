import 'package:test/test.dart';
import 'package:robotize/src/windows.dart';

void main() {

  var windowInfo = WindowInfo(WindowId.fromAddress(123), "Some title", "my_class");

  test("should match window by id", () {
    expect(WindowQuery(windowId: WindowId.fromAddress(123)).windowMatches(windowInfo), true);
  });

  test("should not match if window id does not match", () {
    expect(WindowQuery(windowId: WindowId.fromAddress(321)).windowMatches(windowInfo), false);
  });

  test("matching title by string", () {
    expect(WindowQuery(titleMatcher: "Some title").windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: "Some").windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: "title").windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: "me ti").windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: "other string").windowMatches(windowInfo), false);
  });

  test("matching title by regex", () {
    expect(WindowQuery(titleMatcher: RegExp(r"^Some title$")).windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: RegExp(r"title$")).windowMatches(windowInfo), true);
    expect(WindowQuery(titleMatcher: RegExp(r"^title")).windowMatches(windowInfo), false);
    expect(WindowQuery(titleMatcher: RegExp(r"^Some$")).windowMatches(windowInfo), false);
    expect(WindowQuery(titleMatcher: RegExp(r"other")).windowMatches(windowInfo), false);
  });

  test("matching class by string", () {
    expect(WindowQuery(classMatcher: "y_cla").windowMatches(windowInfo), true);
    expect(WindowQuery(classMatcher: "my_class").windowMatches(windowInfo), true);
    expect(WindowQuery(classMatcher: "other").windowMatches(windowInfo), false);
  });

  test("matching class by regex", () {
    expect(WindowQuery(classMatcher: RegExp(r"class$")).windowMatches(windowInfo), true);
    expect(WindowQuery(classMatcher: RegExp(r"^my_class$")).windowMatches(windowInfo), true);
    expect(WindowQuery(classMatcher: RegExp(r"^class")).windowMatches(windowInfo), false);
  });
}