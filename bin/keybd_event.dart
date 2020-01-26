import 'dart:ffi';
DynamicLibrary _user32 = DynamicLibrary.open("user32.dll");

typedef _keybd_event_C = Void Function(Uint8 bVk, Uint8 bScan, Uint32 dwFlags, Pointer dwExtraInfo);
typedef _keybd_event_Dart = void Function(int bVk, int bScan, int dwFlags, Pointer dwExtraInfo);
var keybd_event = _user32.lookupFunction<_keybd_event_C, _keybd_event_Dart>("keybd_event");

const MAPVK_VK_TO_VSC = 0;
typedef _MapVirtualKeyW_C = Uint32 Function(Uint32 uCode, Uint32 uMapType);
typedef _MapVirtualKeyW_Dart = int Function(int uCode, int uMapType);
var MapVirtualKeyW = _user32.lookupFunction<_MapVirtualKeyW_C, _MapVirtualKeyW_Dart>("MapVirtualKeyW");


void main() {
  keybd_event(
    0x5a, 
    MapVirtualKeyW(0x5a, MAPVK_VK_TO_VSC), 
    0, 
    nullptr);
}
