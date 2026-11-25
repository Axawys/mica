# Mica для Windows

После [подготовки общей локализации](../README.md#сборка) соберите приложение
командой `flutter build windows --release` на Windows.
Переносите весь каталог `build\windows\x64\runner\Release`.
При обновлении сохраняйте путь к `synchronizer_windows.exe`, чтобы продолжали
работать ярлыки, автозапуск и правила брандмауэра. Настройки остаются в
`%APPDATA%\Axawys\Synchronizer\shared_preferences.json`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
