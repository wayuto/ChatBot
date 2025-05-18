# ChatBot

A Flutter-based chatbot application supporting multiple large language models, chat history persistence, and model switching.

## Features

- **Multi-Model Support:** Easily switch between various LLMs (e.g., internlm, Qwen, DeepSeek, GLM).
- **Chat History:** All conversations are automatically saved locally using `SharedPreferences`.
- **Clear History:** Option to clear chat history at any time.
- **Material Design UI:** Clean and intuitive user interface.
- **API Integration:** Connects to LLM APIs (default: [SiliconFlow](https://api.siliconflow.cn/v1/chat/completions)).

## Directory Structure

```
lib/
  main.dart                // Application entry point
  app/
    app.dart               // Root widget
    appState.dart          // State management and core logic
  pages/
    homePage.dart          // Main chat UI
```

## Getting Started

1. **Install dependencies**

   ```bash
   flutter pub get
   ```

2. **Run the app**

   ```bash
   flutter run
   ```

## Core Logic

The main logic is in `lib/app/appState.dart`:

- **State Management:** Uses `ChangeNotifier` for reactive UI updates.
- **Model Switching:** `setModel()` allows users to change the LLM model and clears the chat history.
- **Chat History:** 
  - `addHistory()` adds a message to the history and saves it.
  - `loadHistory()` loads saved messages from local storage.
  - `clear()` removes all chat history.
- **API Communication:** 
  - `getResponse()` sends the chat history and user input to the backend API and handles the response.
  - Handles errors and updates the UI accordingly.

Example API call in `getResponse()`:
```dart
final content = await post(
  Uri.parse("https://api.siliconflow.cn/v1/chat/completions"),
  headers: {
    'Authorization': 'Bearer <YOUR_API_KEY>',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'model': model,
    'messages': [
      {'role': 'system', 'content': 'You are a helpful assistant.'},
      ...history.map((msg) => {'role': msg['role'], 'content': msg['content']}),
    ],
    'stream': false,
  }),
);
```

## Dependencies

- [provider](https://pub.dev/packages/provider) for state management
- [http](https://pub.dev/packages/http) for API requests
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local storage

## Configuration

- **API Key:** The API key is set in `appState.dart`. For security, consider moving it to a secure location or environment variable for production.
- **Model Selection:** Default model is `internlm/internlm2_5-7b-chat`, but you can switch to others as needed.

## License

MIT License