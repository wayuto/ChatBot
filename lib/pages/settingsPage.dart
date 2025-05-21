import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/appState.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  final TextEditingController _promptContronller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              return showDialog(
                context: context,
                builder: (content) {
                  return AlertDialog(
                    title: Text('Set Prompt'),
                    content: TextField(
                      controller: _promptContronller,
                      decoration: InputDecoration(hintText: 'prompt'),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () async {
                          if (_promptContronller.text.isNotEmpty) {
                            await appState.setPrompt(_promptContronller.text);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            title: Text('Prompt'),
          ),
          ListTile(
            onTap: () async {
              var model = await showDialog<String>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text('Choose a model:'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Qwen/QwQ-32B'),
                        child: Text('Qwen/QwQ-32B'),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed:
                            () => Navigator.pop(
                              context,
                              'internlm/internlm2_5-7b-chat',
                            ),
                        child: Text('internlm/internlm2_5-7b-chat'),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed:
                            () => Navigator.pop(
                              context,
                              'deepseek-ai/DeepSeek-V3',
                            ),
                        child: Text('deepseek-ai/DeepSeek-V3'),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed:
                            () =>
                                Navigator.pop(context, 'THUDM/GLM-4-32B-0414'),
                        child: Text('THUDM/GLM-4-32B-0414'),
                      ),
                    ],
                  );
                },
              );
              if (model != null) {
                await appState.setModel(model);
                appState.appBar = "Model: ${appState.model}";
              }
            },
            title: Text('Model'),
          ),
          ListTile(
            onTap: () async {
              bool result = await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text('Clean all history?'),
                    children: [
                      SimpleDialogOption(
                        child: Text('Yes'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  );
                },
              );
              if (result == true) {
                await appState.clear();
              }
            },
            title: Text('Clear'),
          ),
          ListTile(
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Version: v1.2.1'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            title: Text('Version: v1.2.1'),
          ),
        ],
      ),
    );
  }
}
