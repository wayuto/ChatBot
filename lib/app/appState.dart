import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  static const APIKey = 'sk-xyhiljqssfqqhdaqzjggnekvfqipsczmnwmbzifmueasbdrm';
  static const url = 'https://api.siliconflow.cn/v1/chat/completions';
  String response = '';
  var history = <Map<String, String>>[];
  bool isThinking = false;
  String? model;
  String? appBar;
  String? prompt;
  String? theme;

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  MyAppState() {
    init();
  }

  Future<void> setPrompt(String newPrompt) async {
    prompt = newPrompt;
    _prefs.setString('prompt', newPrompt);
    await clearHistory();
  }

  Future<void> setModel(String newModel) async {
    model = newModel;
    loadPrompt();
    _prefs.setString('model', newModel);
    await clearHistory();
  }

  Future<void> loadPrompt() async {
    if (!_isInitialized) return;
    final newPrompt = _prefs.getString('prompt');
    prompt = newPrompt ?? '你叫WBot, 你的开发者是万宇桐(Wan Yutong), 你的语言模型是$model';
    notifyListeners();
  }

  Future<void> loadModel() async {
    if (!_isInitialized) return;
    final newModel = _prefs.getString('model');
    model = newModel ?? 'deepseek-ai/DeepSeek-V3';
    appBar = "Model: $model";
    notifyListeners();
  }

  Future<void> loadHistory() async {
    if (!_isInitialized) return;
    final historyJson = _prefs.getString('history');
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        history = decoded.map((e) => Map<String, String>.from(e)).toList();
      } catch (e) {
        throw ('Error loading history: $e');
      }
    }
    notifyListeners();
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

  Future<void> clearHistory() async {
    history.clear();
    await _prefs.remove('history');
    notifyListeners();
  }

  Future<void> clearPrompt() async {
    prompt = '你叫WBot, 你的开发者是万宇桐(Wan Yutong), 你的语言模型是$model';
    await _prefs.remove('prompt');
    notifyListeners();
  }

  Future<void> getResponse(String text) async {
    try {
      await addHistory({'role': 'user', 'content': text});
      isThinking = true;
      notifyListeners();
      final content = await post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $APIKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': 'Strictly abide by these: {$prompt}'},
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
      }
      isThinking = false;
      notifyListeners();
    } catch (e) {
      response = "Error: $e";
      notifyListeners();
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    await loadModel();
    await loadPrompt();
    await loadHistory();
  }
}
