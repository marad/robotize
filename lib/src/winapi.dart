import 'dart:ffi';
import 'package:ffi/ffi.dart';

DynamicLibrary _user32 = DynamicLibrary.open("user32.dll");

typedef _FindWindowExW_C = Pointer Function(Pointer hWndParent, Pointer hWndChildAfter, Pointer lpszClass, Pointer lpszWindow);
typedef _FindWindowExW_Dart = Pointer Function(Pointer hWndParent, Pointer hWndChildAfter, Pointer lpszClass, Pointer lpszWindow);
var FindWindowExW = _user32.lookupFunction<_FindWindowExW_C, _FindWindowExW_Dart>("FindWindowExW");

typedef _SetActiveWindow_T = Pointer Function(Pointer);
var SetActiveWindow = _user32.lookupFunction<_SetActiveWindow_T, _SetActiveWindow_T>("SetActiveWindow");

typedef _GetDesktopWindow_C = Pointer Function();
typedef _GetDesktopWindow_Dart = Pointer Function();
var GetDesktopWindow = _user32.lookupFunction<_GetDesktopWindow_C, _GetDesktopWindow_Dart>("GetDesktopWindow");

typedef _GetForegroundWindow_C = Pointer Function();
typedef _GetForegroundWindow_Dart = Pointer Function();
var GetForegroundWindow = _user32.lookupFunction<_GetForegroundWindow_C, _GetForegroundWindow_Dart>("GetForegroundWindow");

typedef _SetForegroundWindow_C = Uint32 Function(Pointer);
typedef _SetForegroundWindow_Dart = int Function(Pointer);
var SetForegroundWindow = _user32.lookupFunction<_SetForegroundWindow_C, _SetForegroundWindow_Dart>("SetForegroundWindow");

class Point extends Struct {
  @Uint32() int x;
  @Uint32() int y;

  static Pointer<Point> create({
    int x = 0,
    int y = 0,
  }) {
    var point = allocate<Point>();
    point.ref
      ..x = x
      ..y = y;
    return point;
  }
}

class Rect extends Struct {
  @Uint32() int left;
  @Uint32() int top;
  @Uint32() int right;
  @Uint32() int bottom;

  static Pointer<Rect> create({
    int left = 0,
    int top = 0,
    int right = 0,
    int bottom = 0,
  }) {
    var rect = allocate<Rect>();
    rect.ref
      ..left = left
      ..top = top
      ..right = right
      ..bottom = bottom;
    return rect;
  }

  int get width => right - left;
  int get height => bottom - top;

  @override
  String toString() {
    return "$left, $top, $right $bottom";
  }
}

typedef _GetWindowRect_C = Uint32 Function(Pointer hWnd, Pointer<Rect> lpRect);
typedef _GetWindowRect_Dart = int Function(Pointer hWnd, Pointer<Rect> lpRect);
var GetWindowRect = _user32.lookupFunction<_GetWindowRect_C, _GetWindowRect_Dart>("GetWindowRect");

typedef _GetClientRect_C = Uint32 Function(Pointer hWnd, Pointer lpRect);
typedef _GetClientRect_Dart = int Function(Pointer hWnd, Pointer lpRect);
var GetClientRect = _user32.lookupFunction<_GetClientRect_C, _GetClientRect_Dart>("GetClientRect");

typedef _ClientToScreen_C = Uint32 Function(Pointer hWnd, Pointer lpPoint);
typedef _ClientToScreen_Dart = int Function(Pointer hWnd, Pointer lpPoint);
var ClientToScreen = _user32.lookupFunction<_ClientToScreen_C, _ClientToScreen_Dart>("ClientToScreen");

const SW_HIDE = 0;
const SW_SHOWNORMAL = 1;
const SW_SHOWMINIMIZED = 2;
const SW_SHOWMAXIMIZED = 3;
const SW_MAXIMIZE = 3;
const SW_SHOWNOACTIVATE = 4;
const SW_SHOW= 5;
const SW_MINIMIZE = 6;
const SW_SHOWMINNOACTIVE = 7;
const SW_SHOWNA = 8;
const SW_RESTORE = 9;
const SW_SHOWDEFAULT = 10;
typedef _ShowWindow_C = Uint32 Function(Pointer, Uint32);
typedef _ShowWindow_Dart = int Function(Pointer, int);
var ShowWindow = _user32.lookupFunction<_ShowWindow_C, _ShowWindow_Dart>("ShowWindow");

typedef _IsIconic_C = Uint32 Function(Pointer hWnd);
typedef _IsIconic_Dart = int Function(Pointer hWnd);
var IsIconic = _user32.lookupFunction<_IsIconic_C, _IsIconic_Dart>("IsIconic");

typedef _EnumWindows_C = Uint32 Function(Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
typedef _EnumWindows_Dart = int Function(Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
typedef EnumWindowsCallback = Uint32 Function(Pointer hwnd, Pointer lparam);
var EnumWindows = _user32.lookupFunction<_EnumWindows_C, _EnumWindows_Dart>("EnumWindows");

typedef _EnumChildWindows_C = Uint32 Function(Pointer hwnd, Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
typedef _EnumChildWindows_Dart = int Function(Pointer hwnd, Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
var EnumChildWindows = _user32.lookupFunction<_EnumChildWindows_C, _EnumChildWindows_Dart>("EnumChildWindows");

typedef _GetThreadDesktop_C = Pointer Function(Uint32 threadId);
typedef _GetThreadDestkop_Dart = Pointer Function(int threadId);
var GetThreadDesktop = _user32.lookupFunction<_GetThreadDesktop_C, _GetThreadDestkop_Dart>("GetThreadDesktop");

typedef _EnumDesktopWindows_C = Uint32 Function(Pointer hDesktop, Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
typedef _EnumDesktopWindows_Dart = int Function(Pointer hDesktop, Pointer<NativeFunction<EnumWindowsCallback>> func, Pointer lparam);
var EnumDesktopWindows = _user32.lookupFunction<_EnumDesktopWindows_C, _EnumDesktopWindows_Dart>("EnumDesktopWindows");

typedef _GetWindowTextLengthA_C = Uint32 Function(Pointer hWnd);
typedef _GetWindowTextLengthA_Dart = int Function(Pointer hWnd);
var GetWindowTextLengthA = _user32.lookupFunction<_GetWindowTextLengthA_C, _GetWindowTextLengthA_Dart>("GetWindowTextLengthA");

typedef _GetWindowTextW_C = Uint32 Function(Pointer hWnd, Pointer lpString, Uint32 nMaxCount);
typedef _GetWindowTextW_Dart = int Function(Pointer hWnd, Pointer lpString, int nMaxCount);
var GetWindowTextW = _user32.lookupFunction<_GetWindowTextW_C, _GetWindowTextW_Dart>("GetWindowTextW");

typedef EnumWindowStationsCallback = Uint32 Function(Pointer lpszWindowStation, Pointer lParam);
typedef _EnumWindowStationsA_C = Uint32 Function(Pointer<NativeFunction<EnumWindowStationsCallback>> lpEnumFunc, Pointer lParam);
typedef _EnumWindowStationsA_Dart = int Function(Pointer<NativeFunction<EnumWindowStationsCallback>> lpEnumFunc, Pointer lParam);
var EnumWindowStationsA = _user32.lookupFunction<_EnumWindowStationsA_C, _EnumWindowStationsA_Dart>("EnumWindowStationsA");

typedef _OpenInputDesktop_C = Pointer Function(Uint32 dwFlags, Uint32 fInherit, Uint32 dwDesiredAccess);
typedef _OpenInputDesktop_Dart = Pointer Function(int dwFlags, int fInherit, int dwDesiredAccess);
var OpenInputDesktop = _user32.lookupFunction<_OpenInputDesktop_C, _OpenInputDesktop_Dart>("OpenInputDesktop");

typedef _GetWindowThreadProcessId_C = Uint32 Function(Pointer hWnd, Pointer<Uint32> lpdwProcessId);
typedef _GetWindowThreadProcessId_Dart = int Function(Pointer hWnd, Pointer<Uint32> lpdwProcessId);
var GetWindowThreadProcessId = _user32.lookupFunction<_GetWindowThreadProcessId_C, _GetWindowThreadProcessId_Dart>("GetWindowThreadProcessId");

typedef _CreateWindowExW_C = Pointer Function(Uint32 dwExStyle, Pointer lpClassName, Pointer lpWindowName, Uint32 dwStyle, Uint32 X, Uint32 Y, Uint32 nWidth, Uint32 nHeight, Pointer hWndParent, Pointer hMenu, Pointer hInstance, Pointer lpParam);
typedef _CreateWindowExW_Dart = Pointer Function(int dwExStyle, Pointer lpClassName, Pointer lpWindowName, int dwStyle, int X, int Y, int nWidth, int nHeight, Pointer hWndParent, Pointer hMenu, Pointer hInstance, Pointer lpParam);
var CreateWindowExW = _user32.lookupFunction<_CreateWindowExW_C, _CreateWindowExW_Dart>("CreateWindowExW");


// Window set targets
final GWL_EXSTYLE = -20;
final GWLP_HINSTANCE = -6;
final GWLP_ID = -12;
final GWL_STYLE = -16;
final GWLP_USERDATA = -21;
final GWLP_WNDPROC = -4;


// Window styles
const WS_BORDER = 0x00800000;
const WS_CAPTION = 0x00C00000;
const WS_CHILD = 0x40000000;
const WS_CHILDWINDOW = 0x40000000;
const WS_CLIPCHILDREN = 0x02000000;
const WS_CLIPSIBLINGS = 0x04000000;
const WS_DISABLED = 0x08000000;
const WS_DLGFRAME = 0x00400000;
const WS_GROUP = 0x00020000;
const WS_HSCROLL = 0x00100000;
const WS_ICONIC = 0x20000000;
const WS_MAXIMIZE = 0x01000000;
const WS_MAXIMIZEBOX = 0x00010000;
const WS_MINIMIZE = 0x20000000;
const WS_MINIMIZEBOX = 0x00020000;
const WS_OVERLAPPED = 0x00000000;
const WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
const WS_POPUP = 0x80000000;
const WS_POPUPWINDOW = (WS_POPUP | WS_BORDER | WS_SYSMENU);
const WS_SIZEBOX = 0x00040000;
const WS_SYSMENU = 0x00080000;
const WS_TABSTOP = 0x00010000;
const WS_THICKFRAME = 0x00040000;
const WS_TILED = 0x00000000;
const WS_TILEDWINDOW = (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
const WS_VISIBLE = 0x10000000;

// Window extended styles
const WS_EX_ACCEPTFILES = 0x00000010;
const WS_EX_APPWINDOW = 0x00040000;
const WS_EX_CLIENTEDGE = 0x00000200;
const WS_EX_COMPOSITED = 0x02000000;
const WS_EX_CONTEXTHELP = 0x00000400;
const WS_EX_CONTROLPARENT = 0x00010000;
const WS_EX_DLGMODALFRAME = 0x00000001;
const WS_EX_LAYERED = 0x00080000;
const WS_EX_LAYOUTRTL = 0x00400000;
const WS_EX_LEFT = 0x00000000;
const WS_EX_LEFTSCROLLBAR = 0x00004000;
const WS_EX_LTRREADING = 0x00000000;
const WS_EX_MDICHILD = 0x00000040;
const WS_EX_NOACTIVATE = 0x08000000;
const WS_EX_NOINHERITLAYOUT = 0x00100000;
const WS_EX_NOPARENTNOTIFY = 0x00000004;
const WS_EX_NOREDIRECTIONBITMAP = 0x00200000;
const WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE);
const WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST);
const WS_EX_RIGHT = 0x00001000;
const WS_EX_RIGHTSCROLLBAR = 0x00000000;
const WS_EX_RTLREADING = 0x00002000;
const WS_EX_STATICEDGE = 0x00020000;
const WS_EX_TOOLWINDOW = 0x00000080;
const WS_EX_TOPMOST = 0x00000008;
const WS_EX_TRANSPARENT = 0x00000020;
const WS_EX_WINDOWEDGE = 0x00000100;

typedef _GetWindowLongA_C = Int64 Function(Pointer hWnd, Uint32 nIndex);
typedef _GetWindowLongA_Dart = int Function(Pointer hWnd, int nIndex);
var GetWindowLongA = _user32.lookupFunction<_GetWindowLongA_C, _GetWindowLongA_Dart>("GetWindowLongA");

typedef _GetWindowLongPtrA_C = Pointer Function(Pointer hWnd, Uint32 nIndex);
typedef _GetWindowLongPtrA_Dart = Pointer Function(Pointer hWnd, int nIndex);
var GetWindowLongPtrA = _user32.lookupFunction<_GetWindowLongPtrA_C, _GetWindowLongPtrA_Dart>("GetWindowLongPtrA");

typedef _SetWindowLongPtrA_C = Pointer Function(Pointer hWnd, Uint32 nIndex, Pointer dwNewLong);
typedef _SetWindowLongPtrA_Dart = Pointer Function(Pointer hWnd, int nIndex, Pointer dwNewLong);
var SetWindowLongPtrA = _user32.lookupFunction<_SetWindowLongPtrA_C, _SetWindowLongPtrA_Dart>("SetWindowLongPtrA");

final HWND_BOTTOM = Pointer.fromAddress(1);
final HWND_NOTOPMOST = Pointer.fromAddress(-2);
final HWND_TOP = Pointer.fromAddress(0);
final HWND_TOPMOST = Pointer.fromAddress(-1);

const SWP_ASYNCWINDOWPOS = 0x4000;
const SWP_DEFERERASE = 0x2000;
const SWP_DRAWFRAME = 0x0020;
const SWP_FRAMECHANGED = 0x0020;
const SWP_HIDEWINDOW = 0x0080;
const SWP_NOACTIVATE = 0x0010;
const SWP_NOCOPYBITS = 0x0100;
const SWP_NOMOVE = 0x0002;
const SWP_NOOWNERZORDER = 0x0200;
const SWP_NOREDRAW = 0x0008;
const SWP_NOREPOSITION = 0x0200;
const SWP_NOSENDCHANGING = 0x0400;
const SWP_NOSIZE = 0x0001;
const SWP_NOZORDER = 0x0004;
const SWP_SHOWWINDOW = 0x0040;

// refresh only: SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED

typedef _SetWindowPos_C = Uint32 Function(Pointer hWnd, Pointer hWndInsertAfter, Uint32 X, Uint32 Y, Uint32 cx, Uint32 cy, Uint32 uFlags);
typedef _SetWindowPos_Dart = int Function(Pointer hWnd, Pointer hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags);
var SetWindowPos = _user32.lookupFunction<_SetWindowPos_C, _SetWindowPos_Dart>("SetWindowPos");

typedef _CloseWindow_C = Uint32 Function(Pointer hWnd);
typedef _CloseWindow_Dart = int Function(Pointer hWnd);
var CloseWindow = _user32.lookupFunction<_CloseWindow_C, _CloseWindow_Dart>("CloseWindow");

typedef _DestroyWindow_C = Uint32 Function(Pointer hWnd);
typedef _DestroyWindow_Dart = int Function(Pointer hWnd);
var DestroyWindow = _user32.lookupFunction<_DestroyWindow_C, _DestroyWindow_Dart>("DestroyWindow");

typedef _GetClassNameW_C = Uint32 Function(Pointer hWnd, Pointer lpClassName, Uint32 nMaxCount);
typedef _GetClassNameW_Dart = int Function(Pointer hWnd, Pointer lpClassName, int nMaxCount);
var GetClassNameW = _user32.lookupFunction<_GetClassNameW_C, _GetClassNameW_Dart>("GetClassNameW");

typedef _SendMessageW_C = Pointer Function(Pointer hWnd, Uint32 Msg, Pointer<Uint64> wParam, Pointer<Int64> lParam);
typedef _SendMessageW_Dart = Pointer Function(Pointer hWnd, int Msg, Pointer<Uint64> wParam, Pointer<Int64> lParam);
var SendMessageW = _user32.lookupFunction<_SendMessageW_C, _SendMessageW_Dart>("SendMessageW");

typedef _PostMessageW_C = Uint32 Function(Pointer hWnd, Uint32 Msg, Pointer<Uint64> wParam, Pointer<Int64> lParam);
typedef _PostMessageW_Dart = int Function(Pointer hWnd, int Msg, Pointer<Uint64> wParam, Pointer<Int64> lParam);
var PostMessageW = _user32.lookupFunction<_PostMessageW_C, _PostMessageW_Dart>("PostMessageW");

const INPUT_MOUSE = 0;
const INPUT_KEYBOARD = 1;
const INPUT_HARDWARE = 2;

const KEYEVENTF_EXTENDEDKEY = 0x0001;
const KEYEVENTF_KEYUP = 0x0002;
const KEYEVENTF_UNICODE = 0x0004;
const KEYEVENTF_SCANCODE = 0x0008;

const VK_SHIFT = 0x10;
const VK_ALT = 0x12;
const VK_CTRL = 0x11;
const VK_LWIN = 0x5B;
const VK_RWIN = 0x5C;

const VK_LSHIFT = 0xA0;
const VK_RSHIFT = 0xA1;
const VK_MENU = 0x12;
const VK_RMENU = 0xA5;
const VK_LCONTROL = 0xA2;
const VK_RCONTROL = 0xA3;


class KeyboardInput extends Struct {
  @Uint32() int type;
  @Uint32() int _padding;
  @Uint16() int virtualCode;
  @Uint16() int scanCode;
  @Uint32() int flags;
  @Uint32() int time;
  Pointer dwExtraInfo;
  @Uint64() int _padding2;

  factory KeyboardInput.allocate({
      int virtualKeyCode = 0, 
      int scanCode = 0,
      int flags = 0
    }) =>
    allocate<KeyboardInput>().ref
      ..type = INPUT_KEYBOARD
      ..virtualCode = virtualKeyCode
      ..scanCode = scanCode
      ..flags = flags
      ..time = 0
      ..dwExtraInfo = nullptr
      .._padding = 0
      .._padding2 = 0
      ;
}

const MOUSEEVENTF_ABSOLUTE = 0x8000;
const MOUSEEVENTF_LEFTDOWN = 0x02;
const MOUSEEVENTF_LEFTUP = 0x04;
const MOUSEEVENTF_RIGHTDOWN = 0x08;
const MOUSEEVENTF_RIGHTUP = 0x10;
const MOUSEEVENTF_MIDDLEDOWN = 0x0020;
const MOUSEEVENTF_MIDDLEUP = 0x0040;
const MOUSEEVENTF_MOVE = 0x0001;
const MOUSEEVENTF_WHEEL = 0x0800;
const MOUSEEVENTF_HWHEEL = 0x01000;
const MOUSEEVENTF_XDOWN = 0x0080;
const MOUSEEVENTF_XUP = 0x0100;

class MouseInput extends Struct {
  @Uint32() int type;
  @Uint32() int _padding;
  @Uint32() int dx;
  @Uint32() int dy;
  @Uint32() int mouseData;
  @Uint32() int flags;
  @Uint32() int time;
  Pointer extraInfo;

  factory MouseInput.allocate(int x, int y, {
    int mouseData = 0,
    int flags = 0,
    int time = 0,
  }) => allocate<MouseInput>().ref
    ..type = INPUT_MOUSE
    ..dx = x
    ..dy = y
    ..mouseData = mouseData
    ..flags = flags
    ..time = time
    ;
}


typedef _SendInput_C = Uint32 Function(Uint32 cInputs, Pointer pInputs, Uint32 cbSize);
typedef _SendInput_Dart = int Function(int cInputs, Pointer pInputs, int cbSize);
var SendInput = _user32.lookupFunction<_SendInput_C, _SendInput_Dart>("SendInput");

typedef _keybd_event_C = Void Function(Uint8 bVk, Uint8 bScan, Uint32 dwFlags, Pointer dwExtraInfo);
typedef _keybd_event_Dart = void Function(int bVk, int bScan, int dwFlags, Pointer dwExtraInfo);
var keybd_event = _user32.lookupFunction<_keybd_event_C, _keybd_event_Dart>("keybd_event");

const MAPVK_VK_TO_VSC = 0;
const MAPVK_VSC_TO_VK = 1;
const MAPVK_VK_TO_CHAR = 2;
const MAPVK_VSC_TO_VK_EX = 3;
typedef _MapVirtualKeyW_C = Uint32 Function(Uint32 uCode, Uint32 uMapType);
typedef _MapVirtualKeyW_Dart = int Function(int uCode, int uMapType);
var MapVirtualKeyW = _user32.lookupFunction<_MapVirtualKeyW_C, _MapVirtualKeyW_Dart>("MapVirtualKeyW");

const WM_KEYDOWN = 0x0100;
const WM_KEYUP = 0x0101;
const WM_HOTKEY = 0x0312;
const WH_KEYBOARD_LL = 13;
const WH_SHELL = 10;

const HSHELL_ACCESSIBILITYSTATE = 11;
const HSHELL_ACTIVATESHELLWINDOW = 3;
const HSHELL_APPCOMMAND = 12;
const HSHELL_GETMINRECT = 5;
const HSHELL_LANGUAGE = 8;
const HSHELL_REDRAW = 6;
const HSHELL_TASKMAN = 7;
const HSHELL_WINDOWACTIVATED = 4;
const HSHELL_WINDOWCREATED = 1;
const HSHELL_WINDOWDESTROYED = 2;
const HSHELL_WINDOWREPLACED = 1;

typedef KeyboardProc = Uint32 Function(Uint32 code, Pointer<Uint64> wParam, Pointer<Int64> lParam);
typedef ShellProc = Uint32 Function(Uint32 code, Pointer<Uint64> wParam, Pointer<Int64> lParam);
typedef _SetWindowsHookExW_C = Pointer Function(Uint32 idHook, Pointer lpfn, Pointer hmod, Uint32 dwThreadId);
typedef _SetWindowsHookExW_Dart = Pointer Function(int idHook, Pointer lpfn, Pointer hmod, int dwThreadId);
var SetWindowsHookExW = _user32.lookupFunction<_SetWindowsHookExW_C, _SetWindowsHookExW_Dart>("SetWindowsHookExW");

class KBDLLHOOK extends Struct {
  @Uint32() int vkCode;
  @Uint32() int scanCode;
  @Uint32() int flags;
  @Uint32() int time;
  Pointer dwExtraInfo;
}

typedef _CallNextHookEx_C = Uint32 Function(Pointer hhk, Uint32 nCode, Pointer<Uint64> wParam, Pointer<Int64> lParam);
typedef _CallNextHookEx_Dart = int Function(Pointer hhk, int nCode, Pointer<Uint64> wParam, Pointer<Int64> lParam);
var CallNextHookEx = _user32.lookupFunction<_CallNextHookEx_C, _CallNextHookEx_Dart>("CallNextHookEx");

class MSG extends Struct {
  Pointer hwnd;
  @Uint32() int message;
  Pointer<Uint64> wParam;
  Pointer<Int64> lParam;
  @Uint32() int time;
  @Int64() int pointX;
  @Int64() int pointY;
  @Uint64() int lPrivate;
}

typedef _GetMessage_C = Uint32 Function(Pointer lpMsg, Pointer hWnd, Uint32 wMsgFilterMin, Uint32 wMsgFilterMax);
typedef _GetMessage_Dart = int Function(Pointer lpMsg, Pointer hWnd, int wMsgFilterMin, int wMsgFilterMax);
var GetMessage = _user32.lookupFunction<_GetMessage_C, _GetMessage_Dart>("GetMessageW");

const PM_NOREMOVE = 0x0000;
const PM_REMOVE = 0x0001;
const PM_NOYIELD = 0x0002;

typedef _PeekMessageA_C = Uint32 Function(Pointer lpMsg, Pointer hWnd, Uint32 wMsgFilterMin, Uint32 wMsgFilterMax, Uint32 wRemoveMsg);
typedef _PeekMessageA_Dart = int Function(Pointer lpMsg, Pointer hWnd, int wMsgFilterMin, int wMsgFilterMax, int wRemoveMsg);
var PeekMessageA = _user32.lookupFunction<_PeekMessageA_C, _PeekMessageA_Dart>("PeekMessageA");

typedef _PeekMessageW_C = Uint32 Function(Pointer lpMsg, Pointer hWnd, Uint32 wMsgFilterMin, Uint32 wMsgFilterMax, Uint32 wRemoveMsg);
typedef _PeekMessageW_Dart = int Function(Pointer lpMsg, Pointer hWnd, int wMsgFilterMin, int wMsgFilterMax, int wRemoveMsg);
var PeekMessageW = _user32.lookupFunction<_PeekMessageW_C, _PeekMessageW_Dart>("PeekMessageW");

typedef _TranslateMessage_C = Uint32 Function(Pointer lpMsg);
typedef _TranslateMessage_Dart = int Function(Pointer lpMsg);
var TranslateMessage = _user32.lookupFunction<_TranslateMessage_C, _TranslateMessage_Dart>("TranslateMessageW");

typedef _DispatchMessage_C = Pointer Function(Pointer lpMsg);
typedef _DispatchMessage_Dart = Pointer Function(Pointer lpMsg);
var DispatchMessage = _user32.lookupFunction<_DispatchMessage_C, _DispatchMessage_Dart>("DispatchMessageW");

const MOD_ALT = 0x0001;
const MOD_CONTROL = 0x0002;
const MOD_NOREPEAT = 0x4000;
const MOD_SHIFT = 0x0004;
const MOD_WIN = 0x0008;

typedef _RegisterHotKey_C = Uint32 Function(Pointer hWnd, Uint32 id, Uint32 fsModifiers, Uint32 vk);
typedef _RegisterHotKey_Dart = int Function(Pointer hWnd, int id, int fsModifiers, int vk);
var RegisterHotKey = _user32.lookupFunction<_RegisterHotKey_C, _RegisterHotKey_Dart>("RegisterHotKey");

typedef _UnregisterHotKey_C = Uint32 Function(Pointer hWnd, Uint32 id);
typedef _UnregisterHotKey_Dart = int Function(Pointer hWnd, int id);
var UnregisterHotKey = _user32.lookupFunction<_UnregisterHotKey_C, _UnregisterHotKey_Dart>("UnregisterHotKey");

typedef _GetKeyState_C = Int16 Function(Uint32 nVirtKey);
typedef _GetKeyState_Dart = int Function(int nVirtKey);
var GetKeyState = _user32.lookupFunction<_GetKeyState_C, _GetKeyState_Dart>("GetKeyState");

typedef _GetKeyboardState_C = Uint32 Function(Pointer lpKeyState);
typedef _GetKeyboardState_Dart = int Function(Pointer lpKeyState);
var GetKeyboardState = _user32.lookupFunction<_GetKeyboardState_C, _GetKeyboardState_Dart>("GetKeyboardState");

typedef _SetKeyboardState_C = Uint32 Function(Pointer lpKeyState);
typedef _SetKeyboardState_Dart = int Function(Pointer lpKeyState);
var SetKeyboardState = _user32.lookupFunction<_SetKeyboardState_C, _SetKeyboardState_Dart>("SetKeyboardState");

const CF_BITMAP = 2;
const CF_DIB = 8;
const CF_DIBV5 = 17;
const CF_DIF = 5;
const CF_DSPBITMAP = 0x0082;
const CF_DSPENHMETAFILE = 0x008E;
const CF_DSPMETAFILEPICT = 0x0083;
const CF_DSPTEXT = 0x0081;
const CF_ENHMETAFILE = 14;
const CF_GDIOBJFIRST = 0x0300;
const CF_GDIOBJLAST = 0x03FF;
const CF_HDROP = 15;
const CF_LOCALE = 16;
const CF_METAFILEPICT = 3;
const CF_OEMTEXT = 7;
const CF_OWNERDISPLAY = 0x0080;
const CF_PALETTE = 9;
const CF_PENDATA = 10;
const CF_PRIVATEFIRST = 0x0200;
const CF_PRIVATELAST = 0x02FF;
const CF_RIFF = 11;
const CF_SYLK = 4;
const CF_TEXT = 1;
const CF_TIFF = 6;
const CF_UNICODETEXT = 13;
const CF_WAVE = 12;

typedef _GetClipboardData_C = Pointer Function(Uint32 uFormat);
typedef _GetClipboardData_Dart = Pointer Function(int uFormat);
var GetClipboardData = _user32.lookupFunction<_GetClipboardData_C, _GetClipboardData_Dart>("GetClipboardData");

typedef _SetClipboardData_C = Pointer Function(Uint32 uFormat, Pointer hMem);
typedef _SetClipboardData_Dart = Pointer Function(int uFormat, Pointer hMem);
var SetClipboardData = _user32.lookupFunction<_SetClipboardData_C, _SetClipboardData_Dart>("SetClipboardData");

typedef _OpenClipboard_C = Uint32 Function(Pointer hWndNewOwner);
typedef _OpenClipboard_Dart = int Function(Pointer hWndNewOwner);
var OpenClipboard = _user32.lookupFunction<_OpenClipboard_C, _OpenClipboard_Dart>("OpenClipboard");

typedef _CloseClipboard_C = Uint32 Function();
typedef _CloseClipboard_Dart = int Function();
var CloseClipboard = _user32.lookupFunction<_CloseClipboard_C, _CloseClipboard_Dart>("CloseClipboard");

typedef _EmptyClipboard_C = Uint32 Function();
typedef _EmptyClipboard_Dart = int Function();
var EmptyClipboard = _user32.lookupFunction<_EmptyClipboard_C, _EmptyClipboard_Dart>("EmptyClipboard");

const EVENT_SYSTEM_FOREGROUND = 0x0003;
const WINEVENT_OUTOFCONTEXT = 0x0000;
const WINEVENT_SKIPOWNPROCESS = 0x0002;
const EVENT_OBJECT_CREATE = 0x8000;
const EVENT_OBJECT_DESTROY = 0x8001;

typedef WinEventHookCallback = Void Function(Pointer eventHook, Uint32 event, Pointer hwnd, Uint64 idObject, Uint64 idChild, Uint32 eventThread, Uint32 eventTime);
typedef _SetWinEventHook_C = Pointer Function(Uint32 eventMin, Uint32 eventMax, Pointer hmodWinEventProc, Pointer pfnWinEventProc, Uint32 idProcess, Uint32 idThread, Uint32 dwFlags);
typedef _SetWinEventHook_Dart = Pointer Function(int eventMin, int eventMax, Pointer hmodWinEventProc, Pointer pfnWinEventProc, int idProcess, int idThread, int dwFlags);
var SetWinEventHook = _user32.lookupFunction<_SetWinEventHook_C, _SetWinEventHook_Dart>("SetWinEventHook");

// KERNEL
DynamicLibrary _kernel32 = DynamicLibrary.open("kernel32.dll");

typedef _GetLastError_C = Uint32 Function();
typedef _GetLastError_Dart = int Function();
var GetLastError = _kernel32.lookupFunction<_GetLastError_C, _GetLastError_Dart>("GetLastError");

typedef _GetCurrentThreadId_C = Uint32 Function();
typedef _GetCurrentThreadId_Dart = int Function();
var GetCurrentThreadId = _kernel32.lookupFunction<_GetCurrentThreadId_C, _GetCurrentThreadId_Dart>("GetCurrentThreadId");

typedef _GetModuleFileNameA_C = Uint32 Function(Pointer hProcess, Pointer lpFilename, Uint32 nSize);
typedef _GetModuleFileNameA_Dart = int Function(Pointer hProcess, Pointer lpFilename, int nSize);
var GetModuleFileNameA = _kernel32.lookupFunction<_GetModuleFileNameA_C, _GetModuleFileNameA_Dart>("GetModuleFileNameA");

typedef _GetModuleFileNameExA_C = Uint32 Function(Pointer hProcess, Pointer hModule, Pointer lpFilename, Uint32 nSize);
typedef _GetModuleFileNameExA_Dart = int Function(Pointer hProcess, Pointer hModule, Pointer lpFilename, int nSize);
var GetModuleFileNameExA = _kernel32.lookupFunction<_GetModuleFileNameExA_C, _GetModuleFileNameExA_Dart>("GetModuleFileNameExA");

const PROCESS_QUERY_INFORMATION = 0x0400;
const PROCESS_QUERY_LIMITED_INFORMATION = 0x1000;
const PROCESS_VM_READ = 0x0010;
const PROCESS_VM_WRITE = 0x0020;

typedef _OpenProcess_C = Pointer Function(Uint32 dwDesiredAccess, Uint32 bInheritHandle, Uint32 dwProcessId);
typedef _OpenProcess_Dart = Pointer Function(int dwDesiredAccess, int bInheritHandle, int dwProcessId);
var OpenProcess = _kernel32.lookupFunction<_OpenProcess_C, _OpenProcess_Dart>("OpenProcess");

typedef _QueryFullProcessImageNameA_C = Uint32 Function(Pointer hProcess, Uint32 dwFlags, Pointer lpExeName, Pointer lpdwSize);
typedef _QueryFullProcessImageNameA_Dart = int Function(Pointer hProcess, int dwFlags, Pointer lpExeName, Pointer lpdwSize);
var QueryFullProcessImageNameA = _kernel32.lookupFunction<_QueryFullProcessImageNameA_C, _QueryFullProcessImageNameA_Dart>("QueryFullProcessImageNameA");

typedef _QueryFullProcessImageNameW_C = Uint32 Function(Pointer hProcess, Uint32 dwFlags, Pointer lpExeName, Pointer lpdwSize);
typedef _QueryFullProcessImageNameW_Dart = int Function(Pointer hProcess, int dwFlags, Pointer lpExeName, Pointer lpdwSize);
var QueryFullProcessImageNameW = _kernel32.lookupFunction<_QueryFullProcessImageNameW_C, _QueryFullProcessImageNameW_Dart>("QueryFullProcessImageNameW");

typedef _CloseHandle_C = Uint32 Function(Pointer hObject);
typedef _CloseHandle_Dart = int Function(Pointer hObject);
var CloseHandle = _kernel32.lookupFunction<_CloseHandle_C, _CloseHandle_Dart>("CloseHandle");

typedef _GlobalAlloc_C = Pointer Function(Uint32 uFlags, Uint32 dwBytes);
typedef _GlobalAlloc_Dart = Pointer Function(int uFlags, int dwBytes);
var GlobalAlloc = _kernel32.lookupFunction<_GlobalAlloc_C, _GlobalAlloc_Dart>("GlobalAlloc");

typedef _GlobalLock_C = Pointer Function(Pointer hMem);
typedef _GlobalLock_Dart = Pointer Function(Pointer hMem);
var GlobalLock = _kernel32.lookupFunction<_GlobalLock_C, _GlobalLock_Dart>("GlobalLock");

typedef _GlobalUnlock_C = Uint32 Function(Pointer hMem);
typedef _GlobalUnlock_Dart = int Function(Pointer hMem);
var GlobalUnlock = _kernel32.lookupFunction<_GlobalUnlock_C, _GlobalUnlock_Dart>("GlobalUnlock");

// MSVCRT
DynamicLibrary _msvcrt = DynamicLibrary.open("msvcrt.dll");

typedef _memcpy_C = Pointer Function(Pointer dest, Pointer src, Uint32 count);
typedef _memcpy_Dart = Pointer Function(Pointer dest, Pointer src, int count);
var memcpy = _msvcrt.lookupFunction<_memcpy_C, _memcpy_Dart>("memcpy");

typedef _wmemcpy_C = Pointer Function(Pointer dest, Pointer src, Uint32 count);
typedef _wmemcpy_Dart = Pointer Function(Pointer dest, Pointer src, int count);
var wmemcpy = _msvcrt.lookupFunction<_wmemcpy_C, _wmemcpy_Dart>("wmemcpy");