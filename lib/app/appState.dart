import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  var response = 'No message yet...';
  var history = <Map<String, String>>[];
  String model = 'internlm/internlm2_5-7b-chat';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  MyAppState() {
    init();
  }

  void setModel(var newModel) {
    model = newModel;
    clear();
    notifyListeners();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadHistory();
    _isInitialized = true;
  }

  Future<void> saveHistory() async {
    if (!_isInitialized) return;
    final historyJson = jsonEncode(history);
    await _prefs.setString('history', historyJson);
  }

  Future<void> addHistory(Map<String, String> msg) async {
    history.add(msg);
    await saveHistory();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    if (!_isInitialized) return;
    final historyJson = _prefs.getString('history');
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        history = decoded.map((e) => Map<String, String>.from(e)).toList();
        notifyListeners();
      } catch (e) {
        throw ('Error loading history: $e');
      }
    }
  }

  Future<void> clear() async {
    history.clear();
    await _prefs.remove('history');
    notifyListeners();
  }

  Future<void> getResponse(String text) async {
    try {
      if (text.trim().isEmpty) {
        response = "Message couldn't be empty...";
        notifyListeners();
        return;
      }

      await addHistory({'role': 'user', 'content': text});

      final content = await post(
        Uri.parse("https://api.siliconflow.cn/v1/chat/completions"),
        headers: {
          'Authorization':
              'Bearer sk-xyhiljqssfqqhdaqzjggnekvfqipsczmnwmbzifmueasbdrm',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            ...history.map(
              (msg) => {'role': msg['role'], 'content': msg['content']},
            ),
          ],
          'stream': false,
        }),
      );

      if (content.statusCode == 200) {
        response = jsonDecode(content.body)['choices'][0]['message']['content'];
        await addHistory({'role': 'assistant', 'content': response});
      } else {
        response = "Error: ${content.statusCode}";
        await addHistory({'role': 'assistant', 'content': response});
      }
      notifyListeners();
    } catch (e) {
      response = "Error: $e";
      notifyListeners();
    }
  }
}
