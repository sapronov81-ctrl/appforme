# Barista Pro — Flutter (Android + iOS) + CI/CD

Готовое приложение с вкладками **Аудит** и **Аттестация**, таймером, фото и PDF-отчётами.
Подходит для запуска в **Visual Studio Code** и **Android Studio**.

## Быстрый старт
```bash
# 1) Установи Flutter (stable 3.24.x) и Android Studio
flutter --version

# 2) Создай платформенные папки (android/ios), если их нет
flutter create .

# 3) Подтянь зависимости
flutter pub get

# 4) Сгенерируй иконку и сплэш (опционально на первом запуске)
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

# 5) Запусти
flutter run
```

Если используешь VS Code: открой папку и запусти команду **Flutter: Run**.

## Примеры PDF
- `examples/reports/audit_example.pdf`
- `examples/reports/attestation_example.pdf`

## CI/CD
Смотри `.github/workflows/android-release.yml` и `fastlane/`. Для публикации в Google Play добавь секреты в GitHub (см. README_SETUP.md).
