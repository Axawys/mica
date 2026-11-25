# Mica для Linux

После [подготовки общей локализации](../README.md#сборка) соберите приложение
командой `flutter build linux --release` из этого каталога.
Запускайте `synchronizer_desktop` из каталога `build/linux/<архитектура>/release/bundle`.
При переносе сохраняйте весь каталог сборки.

Для запуска из меню приложений сделайте `synchronizer_desktop` доступным в
`PATH` сеанса рабочего стола, например через ссылку на исполняемый файл из
`~/.local/bin`, если этот каталог уже в `PATH`. Из каталога готовой сборки
скопируйте ярлык и иконки в каталог данных пользователя.

```sh
mica_data="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$mica_data"
cp -R share/applications share/icons "$mica_data/"
```

При обновлении на том же пути ссылка продолжит работать. Повторите копирование,
чтобы обновить ярлык и иконки в меню.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
