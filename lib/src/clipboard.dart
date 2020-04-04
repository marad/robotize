import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:robotize/src/winapi.dart' as winapi;

class Clipboard {
  get text {
    if (winapi.OpenClipboard(nullptr) == 0) {
      print("Error while opening clipboard");
      return "";
    }

    Pointer data = winapi.GetClipboardData(winapi.CF_UNICODETEXT);
    Pointer<Uint16> ctextPointer = winapi.GlobalLock(data).cast();
    if (ctextPointer == nullptr) {
      print("Error while locking clipboard data");
      return "";
    }

    var text = _bufToString(ctextPointer);

    winapi.GlobalUnlock(data);
    winapi.CloseClipboard();

    return text;
  }

  set text(String text) {
    final encodedText = Utf16.toUtf16(text);
    final hMem = winapi.GlobalAlloc(0x0002, (text.length+1) * 2);
    winapi.memcpy(winapi.GlobalLock(hMem), encodedText, text.length * 2);
    winapi.GlobalUnlock(hMem);
    winapi.OpenClipboard(nullptr);
    winapi.SetClipboardData(winapi.CF_UNICODETEXT, hMem);
    winapi.CloseClipboard();
  }

  static String _bufToString(Pointer<Uint16> buffer) {
    int length = 0;
    while(buffer.elementAt(length).value != 0) length++;
    List<int> classChars = buffer.asTypedList(length);
    return String.fromCharCodes(classChars);
  }
}