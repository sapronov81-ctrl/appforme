# GitHub Actions — Secrets & Variables

**Secrets** (Settings → Secrets and variables → Actions → *Secrets*):
- GOOGLE_PLAY_JSON — содержимое service account JSON (для публикации)
- (опц.) ANDROID_KEYSTORE_BASE64, ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS, ANDROID_KEY_ALIAS_PASSWORD — если будешь подписывать Gradle, а не Play App Signing

**Variables** (Settings → Secrets and variables → Actions → *Variables*):
- PACKAGE_NAME — пакет приложения, напр. `com.example.app`
