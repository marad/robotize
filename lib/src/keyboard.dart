import 'package:event_bus/event_bus.dart';
import 'package:robotize/src/keystring.dart';

class KeyEvent {
  String char;
  int keyCode;
  bool down;
  bool up;
  bool shift;
  bool ctrl;
  bool alt;
  bool win;

  KeyEvent(this.char, this.keyCode,
      {this.down = true,
      this.up = true,
      this.shift = false,
      this.ctrl = false,
      this.alt = false,
      this.win = false});

  List<String> get modifiers => [
        shift ? "SHIFT" : null,
        alt ? "ALT" : null,
        ctrl ? "CTRL" : null,
        win ? "LWIN" : null,
      ].where((modifier) => modifier != null).toList();

  @override
  // TODO: implement hashCode
  int get hashCode => 
    char.hashCode ^ keyCode.hashCode ^ down.hashCode ^ up.hashCode ^ shift.hashCode ^ ctrl.hashCode ^ alt.hashCode ^ win.hashCode;

  bool operator==(Object other) =>
    identical(this, other) ||
    other is KeyEvent &&
    other.char == char &&
    other.keyCode == keyCode &&
    other.up == up &&
    other.down == down &&
    other.shift == shift &&
    other.ctrl == ctrl &&
    other.alt == alt &&
    other.win == win;

  @override
  String toString() =>
    "KeyEvent [ char = $char, keyCode = $keyCode, up = $up, down = $down, shift = $shift, ctrl = $ctrl, alt = $alt, win = $win ]";
}

const keyMap = {
  " ": 0x20,
  "0": 0x30,
  "1": 0x31,
  "2": 0x32,
  "3": 0x33,
  "4": 0x34,
  "5": 0x35,
  "6": 0x36,
  "7": 0x37,
  "8": 0x38,
  "9": 0x39,
  "A": 0x41,
  "B": 0x42,
  "C": 0x43,
  "D": 0x44,
  "E": 0x45,
  "F": 0x46,
  "G": 0x47,
  "H": 0x48,
  "I": 0x49,
  "J": 0x4A,
  "K": 0x4B,
  "L": 0x4C,
  "M": 0x4D,
  "N": 0x4E,
  "O": 0x4F,
  "P": 0x50,
  "Q": 0x51,
  "R": 0x52,
  "S": 0x53,
  "T": 0x54,
  "U": 0x55,
  "V": 0x56,
  "W": 0x57,
  "X": 0x58,
  "Y": 0x59,
  "Z": 0x5A,

  "NUM0": 0x60,
  "NUM1": 0x61,
  "NUM2": 0x62,
  "NUM3": 0x63,
  "NUM4": 0x64,
  "NUM5": 0x65,
  "NUM6": 0x66,
  "NUM7": 0x67,
  "NUM8": 0x68,
  "NUM9": 0x69,

  "F1": 0x70,
  "F2": 0x71,
  "F3": 0x72,
  "F4": 0x73,
  "F5": 0x74,
  "F6": 0x75,
  "F7": 0x76,
  "F8": 0x77,
  "F9": 0x78,
  "F10": 0x79,
  "F11": 0x7a,
  "F12": 0x7b,
  "F13": 0x7c,
  "F14": 0x7d,
  "F15": 0x7e,
  "F16": 0x7f,
  "F17": 0x80,
  "F18": 0x81,
  "F19": 0x82,
  "F20": 0x83,
  "F21": 0x84,
  "F22": 0x85,
  "F23": 0x86,
  "F24": 0x87,

  "*": 0x6A,
  "+": 0x6B,
  // " ": 0x6C, // separator?
  // "-": 0x6D,
  // ",": 0x6E, // ??
  "/": 0x6F,
  ",": 0xBC,
  ".": 0xBE,
  "?": 0xBF,
  "`": 0xC0,
  "|": 0xDD,
  "[": 0xDB,
  "]": 0xDD,
  "'": 0xDE,
  "\\": 0xDC,
  "=": 0xBB,
  "-": 0xBD,
  ";": 0xBA,

  "ENTER": 0x0D,
  "TAB": 0x09,
  "SHIFT": 0x10,
  "CTRL": 0x11,
  "ALT": 0x12,
  "ESCAPE": 0x1B,
  "SPACE": 0x20,
  "LWIN": 0x5B,
  "RWIN": 0x5C,
  "SLEEP": 0x5F,
  "CAPSLOCK": 0x14,
  "PAGEUP": 0x21,
  "PAGEDOWN": 0x22,
  "END": 0x23,
  "HOME": 0x24,
  "PRINTSCREEN": 0x2C,
  "INSERT": 0x2D,
  "DELETE": 0x2E,

  "LEFT": 0x25,
  "UP": 0x26,
  "RIGHT": 0x27,
  "DOWN": 0x28,
};


class Keyboard {
  static EventBus _eventBus;

  static List<KeyEvent> decodeEvents(String toSend, {bool raw = false}) {
    if (raw) {
      return rawDecodeEvents(toSend);
    } else {
      return decode(toSend);
    }
  }

  static List<KeyEvent> rawDecodeEvents(String toSend) {
    var keys = <KeyEvent>[];
    for (int i = 0; i < toSend.length; i++) {
      var char = toSend[i];
      if (_specialKeysWithoutShift.contains(char)) {
        keys.add(KeyEvent(char, keyMap[char]));
      } else if (_specialKeysShiftMap.keys.contains(char)) {
        keys.add(
            KeyEvent(char, keyMap[_specialKeysShiftMap[char]], shift: true));
      } else {
        keys.add(KeyEvent(char, keyMap[char.toUpperCase()],
            shift: char == char.toUpperCase()));
      }
    }
    return keys;
  }

  static var _specialKeysWithoutShift = "[];',./`\\=-";
  static var _specialKeysShiftMap = {
    "~": "`",
    "!": "1",
    "@": "2",
    "#": "3",
    "\$": "4",
    "%": "5",
    "^": "6",
    "&": "7",
    "*": "8",
    "(": "9",
    ")": "0",
    "_": "-",
    "+": "=",
    "{": "[",
    "}": "]",
    "|": "\\",
    ":": ";",
    "\"": "'",
    "<": ",",
    ">": ".",
    "?": "/",
  };


  static String keyNameForVirtualKey(int virtualKey) =>
    keyMap.entries.firstWhere((entry) => entry.value == virtualKey, orElse: () => null)?.key;

  static void init(EventBus eventBus) {
    _eventBus = eventBus;
    // var callback = Pointer.fromFunction<winapi.KeyboardProc>(Keyboard._keybdHookProc, 0);
    // var hook = winapi.SetWindowsHookExW(winapi.WH_KEYBOARD_LL, callback, nullptr, 0);
    // if (hook == nullptr) {
    //   // TODO: handle error
    //   print('couldnt register the hook');
    // } else {
    //   print('Hook registered');
    // }
  }

  // static int _keybdHookProc(int code, Pointer<Uint64> wParam, Pointer<Int64> lParam) {
  //   var event = wParam.address;
  //   Pointer<winapi.KBDLLHOOK> dataPtr = lParam.cast();
  //   var data = dataPtr.ref;

  //   _eventBus.fire(KeyEvent(null, data.vkCode));

  //   return winapi.CallNextHookEx(nullptr, code, wParam, lParam);
  // }

}