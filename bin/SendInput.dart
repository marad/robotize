import 'dart:ffi';
import 'package:ffi/ffi.dart';

const INPUT_KEYBOARD = 1;
const KEYEVENTF_UNICODE = 0x0004;

DynamicLibrary _user32 = DynamicLibrary.open("user32.dll");
DynamicLibrary _kernel32 = DynamicLibrary.open("kernel32.dll");

typedef _SendInput_C = Uint32 Function(
    Uint32 cInputs, Pointer pInputs, Uint32 cbSize);
typedef _SendInput_Dart = int Function(
    int cInputs, Pointer pInputs, int cbSize);
var SendInput =
    _user32.lookupFunction<_SendInput_C, _SendInput_Dart>("SendInput");

typedef _GetLastError_C = Uint32 Function();
typedef _GetLastError_Dart = int Function();
var GetLastError = _kernel32
    .lookupFunction<_GetLastError_C, _GetLastError_Dart>("GetLastError");

class KeyboardInput extends Struct {
  @Uint64()
  int type;
  @Uint16()
  int virtualCode;
  @Uint16()
  int scanCode;
  @Uint64()
  int flags;
  @Uint64()
  int time;
  Pointer dwExtraInfo;

  factory KeyboardInput.allocate({int vkey = 0, int scan = 0, int flags = 0}) =>
      allocate<KeyboardInput>().ref
        ..type = INPUT_KEYBOARD
        ..virtualCode = vkey
        ..scanCode = scan
        ..flags = flags
        ..time = 0
        ..dwExtraInfo = nullptr;
}

void main() {
  var zKeyVirtualCoe = 0x5a;
  var event = KeyboardInput.allocate(vkey: zKeyVirtualCoe);
  // this loop will send less than 10 'z' characters (sometimes even zero)
  for (var i = 0; i < 10; i++) {
    print('Sending $i-th virtual character');
    var written = SendInput(1, event.addressOf, 40);
    print('Written $written');
    print('Error ${GetLastError()}');
  }

  // this does not work at all
  var unicode =
      KeyboardInput.allocate(scan: 'z'.codeUnitAt(0), flags: KEYEVENTF_UNICODE);
  for (var i = 0; i < 10; i++) {
    print('Sending $i-th unicode character');
    var written = SendInput(1, unicode.addressOf, 40);
    print('Written $written');
    print('Error ${GetLastError()}');
  }

  print('Struct size: ${sizeOf<KeyboardInput>()}');
}
