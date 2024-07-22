import 'dart:async';
import 'dart:ffi';
import 'package:event_bus/event_bus.dart';
import 'package:ffi/ffi.dart';
import 'package:robotize/src/models.dart';
import 'package:robotize/src/winapi_main.dart';
import 'winapi.dart' as winapi;

// Funkcje do zaimplementowania w pierwszej kolejnosci
// [x] Pobranie aktywnego okna (GetActiveWindow)
// [x] Aktywowanie Okna (SetActiveWindow / SetForegroundWindow)
// [x] Wysłanie wciśnięć klawiszy (SendInput)
// [x] Wysłanie kliknięcia
// [x] - kliknięcie relatywnie do ekranu
// [x] - kliknięcie relatywnie do okna (ScreenToClient / ClientToScreen)
// [x] Czytanie clipboardu / Zapisywanie do clipboardu
// [x] Szukanie Okna (FinwWindowExA)
// [x] - Szukanie po ID
// [x] - Szukanie po tytule
// [x] - Szukanie po klasie
// [ ] - Szukanie po nazwie programu
// [ ] Oczekiwanie aż okno będzie aktywne
// [ ] Oczekiwanie aż okno przestanie być aktywne
// [ ] Oczekiwanie aż okno zostanie zamknięte
// [x] Maxymalizowanie / minimalizowanie okna
// [x] Zamknięcie okna
// [ ] Ustawianie flag (np. AlwaysOnTop itp.) (AHK: WinSet)
// [x] Ukrycie / Pokazanie okna
// [x] RegisterHotkey / UnregisterHotkey
// [ ] DllCall?

// ================================================================================
//
// Querying Window Info
//
// ================================================================================

class WindowId {
  final int windowId;
  WindowId(this.windowId);
  factory WindowId.fromAddress(int address) => WindowId(address);
  factory WindowId.fromPointer(Pointer hwnd) => WindowId(hwnd.address);
  Pointer asPointer() => Pointer.fromAddress(windowId);
}

class WindowQuery {
  final WindowId windowId;
  final Pattern titleMatcher;
  final Pattern classMatcher;
  final Pattern exeNameMatcher;
  final bool onlyVisible;

  WindowQuery(
      {this.windowId,
      this.titleMatcher,
      this.classMatcher,
      this.exeNameMatcher,
      this.onlyVisible = true});

  bool windowMatches(WindowInfo candidate) {
    var windowIdMatches = this.windowId != null
        ? this.windowId.windowId == candidate.id.windowId
        : true;
    return windowIdMatches &&
        _titleMatches(candidate.title) &&
        _classMatcher(candidate.className) &&
        _exeNameMatches(candidate.exeName);
  }

  bool _titleMatches(String title) => _filterMatch(titleMatcher, title);
  bool _classMatcher(String title) => _filterMatch(classMatcher, title);
  bool _exeNameMatches(String exeName) => _filterMatch(exeNameMatcher, exeName);

  bool _filterMatch(Pattern pattern, String toMatch) {
    if (pattern == null) {
      return true;
    }
    return pattern.allMatches(toMatch).length > 0;
  }
}


class Windows {
  Windows(this._eventBus);
  final EventBus _eventBus;

  Window getActiveWindow() =>
      Window(WindowId.fromPointer(winapi.GetForegroundWindow()));

  Window getDesktopWindow() =>
    Window(WindowId.fromPointer(winapi.GetDesktopWindow()));

  Window getWindow(WindowId id) => Window(id);

  /// Lists windows. If query is not provided, lists only visible windows.
  List<Window> list({WindowQuery query}) {
    if (query != null && query.windowId != null) {
      // find and examine only one window
      var window = getWindow(query.windowId);
      if (query.windowMatches(window.getWindowInfo())) {
        return [window];
      } else {
        return [];
      }
    } else {
      // find and filter all windows
      var reducer = _WindowCollector.allocate(
          500, query != null ? query.onlyVisible : true);
      var func = Pointer.fromFunction<winapi.EnumWindowsCallback>(_windowFoundCallback, 0);
      winapi.EnumWindows(func, reducer.addressOf);
      var result = <WindowId>[];
      for (var i = 0; i < reducer.numWindows; i++) {
        var id = reducer.windows.elementAt(i).value;
        var windowId = WindowId.fromAddress(id);
        result.add(windowId);
      }
      if (query != null) {
        return result.map(getWindow)
          .where((window) => query.windowMatches(window.getWindowInfo()))
          .toList();
      } else {
        return result.map(getWindow).toList();
      }
    }
  }

  Window find(WindowQuery query) {
    var windows = list(query: query);
    if (windows.length > 0) {
      return windows.first;
    } else {
      return null;
    }
  }

  Future<Window> waitActive(WindowQuery query) {
    var completer = Completer<Window>();
    StreamSubscription<WindowChanged> subscription = null;
    subscription = _eventBus.on<WindowChanged>().listen((event) {
      var window = event.newWindow;
      if (query.windowMatches(window.getWindowInfo())) {
        completer.complete(window);
        subscription.cancel();
      }
    });
    return completer.future;
  }

  Future<void> waitInactive(WindowQuery query) {
    var completer = Completer();
    StreamSubscription<WindowChanged> subscription = null;
    subscription = _eventBus.on<WindowChanged>().listen((event) {
      var window = event.newWindow;
      if (!query.windowMatches(window.getWindowInfo())) {
        completer.complete();
        subscription.cancel();
      }
    });

    var activeWindow = getActiveWindow();
    if (!query.windowMatches(activeWindow.getWindowInfo())) {
      subscription.cancel();
      completer.complete();
    }
    return completer.future;
  }
}

class Window {
  WindowId _id;

  Window(this._id);

  Pointer get hwnd => _id.asPointer();

  WindowInfo getWindowInfo() {
    var buffer = allocate<Uint16>(count: 257);
    var readChars = winapi.GetClassNameW(hwnd, buffer, 257);
    String className = _bufToString(buffer, readChars);
    free(buffer);
    return WindowInfo(_id, getWindowText(), className, getExeName());
  }

  String getExeName() {
    var processIdPointer = allocate<Uint32>();
    winapi.GetWindowThreadProcessId(hwnd, processIdPointer);
    var processId = processIdPointer.value;
    var processHandle = winapi.OpenProcess(winapi.PROCESS_QUERY_LIMITED_INFORMATION, 0, processId);
    var bufferLen = 1000;
    var buffer = allocate<Uint16>(count: bufferLen);
    var length = allocate<Uint32>();
    length.value = bufferLen;
    winapi.QueryFullProcessImageNameW(processHandle, 0, buffer, length);
    var exeName = _bufToString(buffer, length.value);
    winapi.CloseHandle(processHandle);
    free(buffer);
    return exeName;
  }

  static String _bufToString(Pointer<Uint16> buffer, int length) {
    List<int> classChars = buffer.asTypedList(length);
    return String.fromCharCodes(classChars);
  }

  /// Returns text from provided window or control.
  String getWindowText() {
    var length = winapi.GetWindowTextLengthA(hwnd);
    var buffer = allocate<Uint16>(count: length + 1);
    var readChars = winapi.GetWindowTextW(hwnd, buffer, length + 1);
    List<int> chars = buffer.asTypedList(readChars);
    free(buffer);
    return String.fromCharCodes(chars);
  }

  Point clientToScreen(Point input) {
    var winapiPoint = winapi.Point.create(x: input.x, y: input.y);
    winapi.ClientToScreen(hwnd, winapiPoint);
    return Point(x: winapiPoint.ref.x, y: winapiPoint.ref.y);
  }

  Rect getWindowRect() {
    var winapiRect = winapi.Rect.create();
    winapi.GetWindowRect(hwnd, winapiRect);
    return Rect(
      left: winapiRect.ref.left,
      top: winapiRect.ref.top,
      right: winapiRect.ref.right,
      bottom: winapiRect.ref.bottom,
    );
  }

  Rect getClientRect() {
    var winapiRect = winapi.Rect.create();
    winapi.GetClientRect(hwnd, winapiRect);
    return Rect(
      left: winapiRect.ref.left,
      top: winapiRect.ref.top,
      right: winapiRect.ref.right,
      bottom: winapiRect.ref.bottom,
    );
  }

  bool activateWindow() {
    var window_c = _id != null ? _id.asPointer() : nullptr;
    var isIconic = winapi.IsIconic(window_c);
    if (isIconic > 0) {
      winapi.ShowWindow(window_c, winapi.SW_RESTORE);
    }
    winapi.SetActiveWindow(window_c);
    var ret = winapi.SetForegroundWindow(window_c);
    return ret > 0;
  }

  /// Returns true if window was previously visible.
  bool showWindow() {
    return winapi.ShowWindow(_id.asPointer(), winapi.SW_SHOW) > 0;
  }

  /// Returns true if window was previously visible.
  bool hideWindow() {
    return winapi.ShowWindow(_id.asPointer(), winapi.SW_HIDE) > 0;
  }

  /// Returns true if window was previously visible.
  bool maximizeWindow() {
    return winapi.ShowWindow(_id.asPointer(), winapi.SW_MAXIMIZE) > 0;
  }

  /// Returns true if window was previously visible.
  bool minimizeWindow() {
    return winapi.ShowWindow(_id.asPointer(), winapi.SW_MINIMIZE) > 0;
  }

  bool restoreWindow() {
    return winapi.ShowWindow(_id.asPointer(), winapi.SW_RESTORE) > 0;
  }

  void quitWindow() {
    sendMessage(0x0012, 0, 0);
    // return winapi.DestroyWindow(id.asPointer()) > 0;
  }

  bool isAlwaysOnTop() {
    var styles = winapi.GetWindowLongPtrA(hwnd, winapi.GWL_EXSTYLE).address;
    return styles & winapi.WS_EX_TOPMOST == winapi.WS_EX_TOPMOST;
  }

  void setAlwaysOnTop(bool alwaysOnTop) {
    winapi.SetWindowPos(
      hwnd, 
      alwaysOnTop ? winapi.HWND_TOPMOST : winapi.HWND_NOTOPMOST,
      0, 0, 0, 0,
      winapi.SWP_NOMOVE | winapi.SWP_NOSIZE | winapi.SWP_FRAMECHANGED);
  }

  void bringToTop() {
    winapi.SetWindowPos(
      hwnd,
      winapi.HWND_TOP,
      0, 0, 0, 0,
      winapi.SWP_NOMOVE | winapi.SWP_NOSIZE | winapi.SWP_ASYNCWINDOWPOS
    );
  }

  void sendToBottom() {
    winapi.SetWindowPos(
      hwnd,
      winapi.HWND_BOTTOM,
      0, 0, 0, 0,
      winapi.SWP_NOMOVE | winapi.SWP_NOSIZE | winapi.SWP_ASYNCWINDOWPOS
    );
  }

  void setPosition(int x, int y) {
    winapi.SetWindowPos(
      hwnd,
      nullptr,
      x, y, 0, 0,
      winapi.SWP_NOSIZE | winapi.SWP_NOZORDER | winapi.SWP_ASYNCWINDOWPOS
    );
  }

  void setSize(int width, int height) {
    winapi.SetWindowPos(
      hwnd,
      nullptr,
      0, 0, width, height,
      winapi.SWP_NOMOVE | winapi.SWP_NOZORDER | winapi.SWP_ASYNCWINDOWPOS
    );
  }

  void updateStyle(final int update, {FlagUpdateType updateType = FlagUpdateType.SetFlag}) {
    final current = winapi.GetWindowLongPtrA(hwnd, winapi.GWL_STYLE).address;
    winapi.SetWindowLongPtrA(
      hwnd, winapi.GWL_STYLE,
      Pointer.fromAddress(_flagUpdate(current, update, updateType)));
  }

  void updateExStyle(final int update, {FlagUpdateType updateType = FlagUpdateType.SetFlag}) {
    final current = winapi.GetWindowLongPtrA(hwnd, winapi.GWL_EXSTYLE).address;
    winapi.SetWindowLongPtrA(
      hwnd, winapi.GWL_EXSTYLE,
      Pointer.fromAddress(_flagUpdate(current, update, updateType)));
  }

  int _flagUpdate(int current, int update, FlagUpdateType updateType) {
    switch (updateType) {
      case FlagUpdateType.Reset: return update;
      case FlagUpdateType.SetFlag: return current | update;
      case FlagUpdateType.Toggle: return current ^ update;
      case FlagUpdateType.UnsetFlag: return current & (-1 ^ update);
    }
    return current;
  }

  int postMessage(int msg, int wparam, int lparam) {
    var wparam_c =  allocate<Uint64>();
    var lparam_c = allocate<Int64>();
    var result = winapi.PostMessageW(_id.asPointer(), msg, wparam_c, lparam_c);
    free(wparam_c);
    free(lparam_c);
    return result;
  }

  int sendMessage(int msg, int wparam, int lparam) {
    var wparam_c =  allocate<Uint64>();
    var lparam_c = allocate<Int64>();
    var result = winapi.PostMessageW(_id.asPointer(), msg, wparam_c, lparam_c);
    free(wparam_c);
    free(lparam_c);
    return result;
  }
}

class WindowInfo {
  final WindowId id;
  final String title;
  final String className;
  final String exeName;

  WindowInfo(this.id, this.title, this.className, this.exeName);

  @override
  String toString() {
    return "ID: ${id.windowId}, class: $className, title: $title, exeName: $exeName";
  }
}

enum FlagUpdateType {
  Reset, SetFlag, Toggle, UnsetFlag
}

class _WindowCollector extends Struct {
  @Uint32()
  int capacity;
  @Uint32()
  int numWindows;
  Pointer<Uint32> windows;
  @Uint32()
  int onlyVisible;

  factory _WindowCollector.allocate(int capacity, bool onlyVisible) =>
      allocate<_WindowCollector>().ref
        ..capacity = capacity
        ..numWindows = 0
        ..onlyVisible = onlyVisible ? 1 : 0
        ..windows = allocate<Uint32>(count: capacity);

  void addWindow(int windowId) {
    // TODO: if capacity is reached - allocate more and copy (memcpy)
    windows[numWindows++] = windowId;
  }
}

int _windowFoundCallback(Pointer hwnd, Pointer lparam) {
  _WindowCollector reducer = lparam.cast<_WindowCollector>().ref;

  if (reducer.onlyVisible == 1 &&
      (winapi.GetWindowLongA(hwnd, winapi.GWL_STYLE) & winapi.WS_VISIBLE) == 0) {
    return 1;
  }

  reducer.addWindow(hwnd.address);
  return 1;
}