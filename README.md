# WBot

A cross-platform AI chatbot app built with Flutter.  
Supports Markdown rendering, code highlighting, model selection, persistent chat history, and light/dark/system themes.

Try it in [GitHub Pages](https://wayuto.github.io)

---

## Features

- **Chat with AI**: Supports multiple AI models, selectable in settings.
- **Markdown Rendering**: Supports code blocks, syntax highlighting, and clickable links.
- **Theme Adaptation**: Follows system theme, or can be set to light/dark manually.
- **Persistent History**: Chat history and settings are saved locally.
- **Custom Prompt**: Set your own system prompt for the AI.

---

## Getting Started

### 1. Install dependencies

```sh
flutter pub get
```

### 2. Run the app

```sh
flutter run
```

### 3. Build universal APK

```sh
flutter build apk --release --universal
```
The APK will be in `build/app/outputs/flutter-apk/app-universal.apk`.

---

## Usage Guide

### Chat

- Type your message in the input box at the bottom and press the send button.
- The AI will reply, and the chat will scroll to the latest message automatically.
- Markdown and code blocks in AI replies are rendered with syntax highlighting.

### Settings

- Tap the settings icon in the top right to open the settings page.
- **Prompt**: Set a custom system prompt for the AI.
- **Model**: Choose from multiple AI models.
- **Clear**: Clear chat history or prompt.
- **Theme**: Switch between light, dark, or system theme.
- **Version**: Tap to view the current app version.

---

## Code Structure

```
lib/
  main.dart                # App entry, theme provider setup
  app/
    app.dart               # App widget, theme logic, ThemeNotifier
    appState.dart          # App state: chat history, model, prompt, API logic
  pages/
    homePage.dart          # Main chat UI and logic
    settingsPage.dart      # Settings UI and logic
  widgets/
    syntaxHighlighter.dart # Custom code syntax highlighter for Markdown
```

---

## Key Code Explanation

### Theme Management

- `ThemeNotifier` in [`app/app.dart`](lib/app/app.dart) manages theme mode (light/dark/system) and persists it with `SharedPreferences`.
- The app follows system theme by default, but can be changed in settings.

### Chat State

- `MyAppState` in [`app/appState.dart`](lib/app/appState.dart) manages chat history, current model, prompt, and API requests.
- Chat history and settings are persisted locally.

### Markdown & Code Highlighting

- Markdown is rendered using [`flutter_markdown`](https://pub.dev/packages/flutter_markdown).
- Code blocks are highlighted using a custom `MySyntaxHighlighter` ([`widgets/syntaxHighlighter.dart`](lib/widgets/syntaxHighlighter.dart)), which uses the [`highlight`](https://pub.dev/packages/highlight) package.

### Settings Page

- [`pages/settingsPage.dart`](lib/pages/settingsPage.dart) provides UI for prompt/model/theme/version management.
- Uses dialogs and radio lists for selection.

---

## Customizing the App Icon

1. Place your icon at `assets/icon.png`.
2. In `pubspec.yaml`:

    ```yaml
    flutter_launcher_icons:
      android: true
      ios: true
      windows: true
      macos: true
      image_path: "assets/icon.png"
    ```

3. Run:

    ```sh
    flutter pub run flutter_launcher_icons:main
    ```

---

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [flutter_markdown](https://pub.dev/packages/flutter_markdown)
- [highlight](https://pub.dev/packages/highlight)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [package_info_plus](https://pub.dev/packages/package_info_plus)
- [auto_size_text](https://pub.dev/packages/auto_size_text)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

## License

MIT
