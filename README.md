# ChatBot

A cross-platform chatbot application built with Flutter, supporting Markdown rendering, code highlighting, and customizable AI models.

## Project Structure

```
lib/
  main.dart
  app/
    app.dart           # App entry and theme setup
    appState.dart      # App state management (Provider)
  pages/
    homePage.dart      # Main chat UI and logic
  widgets/
    syntaxHighlighter.dart # Code highlighting for Markdown
```

## Getting Started

### 1. Install Dependencies

```sh
flutter pub get
```

### 2. Run the App

```sh
flutter run
```

### 3. Build Universal APK

```sh
flutter build apk
```

The APK will be in `build/app/outputs/flutter-apk/app-release.apk`.

## Dependencies

Key packages used:

- [provider](https://pub.dev/packages/provider)
- [flutter_markdown](https://pub.dev/packages/flutter_markdown)
- [highlight](https://pub.dev/packages/highlight)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

## License

MIT
