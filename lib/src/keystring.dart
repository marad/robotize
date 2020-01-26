import 'dart:collection';
import 'keyboard.dart';

var shiftKey = "+".codeUnitAt(0);
var altKey = "!".codeUnitAt(0);
var ctrlKey = "^".codeUnitAt(0);
var winKey = "#".codeUnitAt(0);
var startFormat = "{".codeUnitAt(0);
var endFormat = "}".codeUnitAt(0);
var space = " ".codeUnitAt(0);

var _specialKeysWithoutShift = "[];',./`\\=-";
var _specialKeysShiftMap = {
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



List<KeyEvent> decode(String keystring) {
  var tokens = tokenizeKeystring(keystring);
  return decodeKeysFromTokens(tokens);
}

List<String> tokenizeKeystring(String keystring) {
  var tokens = <String>[];
  var chars = Queue<int>.from(keystring.codeUnits);

  while(chars.isNotEmpty) {
    if (chars.first == startFormat) {
      tokens.add(String.fromCharCode(chars.removeFirst())); // starting {
      var keyName = _readTokenTill(chars, {endFormat, space});
      if (keyName != '') {
        tokens.add(keyName);
      } else if (chars.first == endFormat){  // maybe it's '}'
        keyName = String.fromCharCode(chars.removeFirst());
        if (chars.first == endFormat || chars.first == space) {
          tokens.add(keyName);
        }
      }

      if (chars.isEmpty) {
        throw "expected '}' or ' ' characters";
      }
      else if (chars.first == endFormat) {
        tokens.add(String.fromCharCode(chars.removeFirst()));
      } else if (chars.first == space) {
        chars.removeFirst(); // the space
        tokens.add(_readTokenTill(chars, {endFormat}));
      }
    }  else {
      tokens.add(String.fromCharCode(chars.removeFirst()));
    }
  }

  return tokens;
}

String _readTokenTill(Queue<int> chars, Set<int> breakPoints) {
  var tokenChars = <int>[];
  while(chars.isNotEmpty && !breakPoints.contains(chars.first)) {
    tokenChars.add(chars.removeFirst());
  }
  return String.fromCharCodes(tokenChars);
}


List<KeyEvent> decodeKeysFromTokens(List<String> tokens) {
  var q = Queue<String>.from(tokens);
  var events = <KeyEvent>[];
  var currentEvent = KeyEvent(null, null);

  while(q.isNotEmpty) {
    if (q.first == "{") {
      decodeFormattedKey(q, currentEvent);
      events.add(currentEvent);
      currentEvent = KeyEvent(null, null);
    } 
    else if (q.first == "#") {
      q.removeFirst();
      currentEvent.win = true;
    }
    else if (q.first == "!") {
      q.removeFirst();
      currentEvent.alt = true;
    }
    else if (q.first == "+") {
      q.removeFirst();
      currentEvent.shift = true;
    }
    else if (q.first == "^") {
      q.removeFirst();
      currentEvent.ctrl = true;
    }
    else {
      var char = q.removeFirst();
      currentEvent.char = char;
      currentEvent.keyCode = keyMap[char.toUpperCase()];
      if (!currentEvent.shift && char == char.toUpperCase()) {
        currentEvent.shift = true;
      }
      events.add(currentEvent);
      currentEvent = KeyEvent(null, null);
    }
  }
  return events;
}

void decodeFormattedKey(Queue<String> q, KeyEvent event) {
  q.removeFirst();
  var keyName = q.removeFirst();
  event.char = keyName;
  
  if (_specialKeysWithoutShift.contains(keyName)) {
    event.keyCode = keyMap[keyName];
  } else if (_specialKeysShiftMap.containsKey(keyName)) {
    event.keyCode = keyMap[_specialKeysShiftMap[keyName]];
    event.shift = true;
  } else {
    event.keyCode = keyMap[keyName.toUpperCase()];
  }

  if (q.first == "}") {
    q.removeFirst();
    return;
  } else {
    var state = q.removeFirst();
    if (state == "up") {
      event.up = true;
      event.down = false;
    } else if (state == "down") {
      event.up = false;
      event.down = true;
    } else {
      throw "Invalid key state: $state";
    }
  }

  if (q.first != "}") {
    throw "Expected '}', but got ${q.first}";
  }
  q.removeFirst();
}