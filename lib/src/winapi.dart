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

const GWL_STYLE = -16;
const WS_VISIBLE = 0x10000000;
typedef _GetWindowLongA_C = Int64 Function(Pointer hWnd, Uint32 nIndex);
typedef _GetWindowLongA_Dart = int Function(Pointer hWnd, int nIndex);
var GetWindowLongA = _user32.lookupFunction<_GetWindowLongA_C, _GetWindowLongA_Dart>("GetWindowLongA");

typedef _CreateWindowExW_C = Pointer Function(Uint32 dwExStyle, Pointer lpClassName, Pointer lpWindowName, Uint32 dwStyle, Uint32 X, Uint32 Y, Uint32 nWidth, Uint32 nHeight, Pointer hWndParent, Pointer hMenu, Pointer hInstance, Pointer lpParam);
typedef _CreateWindowExW_Dart = Pointer Function(int dwExStyle, Pointer lpClassName, Pointer lpWindowName, int dwStyle, int X, int Y, int nWidth, int nHeight, Pointer hWndParent, Pointer hMenu, Pointer hInstance, Pointer lpParam);
var CreateWindowExW = _user32.lookupFunction<_CreateWindowExW_C, _CreateWindowExW_Dart>("CreateWindowExW");

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


class KeyboardInput extends Struct {
  @Uint64() int type;
  @Uint16() int virtualCode;
  @Uint16() int scanCode;
  @Uint64() int flags;
  @Uint64() int time;
  @Uint64() int dwExtraInfo;
  // Pointer dwExtraInfo;

  factory KeyboardInput.allocate(int virtualCode, int scanCode, int flags) =>
    allocate<KeyboardInput>().ref
      ..type = INPUT_KEYBOARD
      ..virtualCode = virtualCode
      ..scanCode = scanCode
      ..flags = flags
      ..time = 0
      ..dwExtraInfo = 0
      ;
}


class _MouseInput extends Struct {
  @Uint64()
  int dx;
  @Uint64()
  int dy;
  @Uint32()
  int mouseData;
  @Uint32()
  int flags;
  @Uint32()
  int time;
  Pointer extraInfo;
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
typedef KeyboardProc = Uint32 Function(Uint32 code, Pointer<Uint64> wParam, Pointer<Int64> lParam);
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

typedef _OpenProcess_C = Pointer Function(Uint32 dwDesiredAccess, Uint32 bInheritHandle, Uint32 dwProcessId);
typedef _OpenProcess_Dart = Pointer Function(int dwDesiredAccess, int bInheritHandle, int dwProcessId);
var OpenProcess = _kernel32.lookupFunction<_OpenProcess_C, _OpenProcess_Dart>("OpenProcess");

typedef _CloseHandle_C = Uint32 Function(Pointer hObject);
typedef _CloseHandle_Dart = int Function(Pointer hObject);
var CloseHandle = _kernel32.lookupFunction<_CloseHandle_C, _CloseHandle_Dart>("CloseHandle");