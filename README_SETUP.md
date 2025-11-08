# README_SETUP — Установка и запуск (Windows / macOS)

## Предпосылки
- Flutter 3.24.x (stable), Dart 3.4.x
- Android Studio (latest) + Android SDK + AVD
- Git for Windows (2.51.2 x64)

## Шаги
1. Распакуй архив и открой папку в VS Code или Android Studio.
2. В терминале выполни:
   ```bash
   flutter create .
   flutter pub get
   flutter pub run flutter_launcher_icons
   flutter pub run flutter_native_splash:create
   flutter run
   ```
3. Чтобы собрать релиз (Android APK/AAB):
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   ```

## Публикация (Android) через GitHub Actions
1. Добавь репозиторий на GitHub и секреты (см. scripts/set_github_secrets.md).
2. Создай тег `v1.0.0` → запустится сборка релиза и появятся артефакты APK/AAB.
