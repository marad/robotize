# Poposed new API

```dart
Desktop {
    list/find windows -> List<Window>
    clipboard
    notifications
    sendInput()
    click()
    events
    hotkeys
    default settings (keyPressDuration)
}

Window {
    basic info: id, title, name, class, etc.
    state: visibility, flags, maximize/minimize, activate, close, kill etc.
}
```