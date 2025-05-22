import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:WBot/app/appState.dart';
import 'package:WBot/app/app.dart';

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
                      RadioListTile(
                        title: Text('deepseek-ai/DeepSeek-V3'),
                        value: 'deepseek-ai/DeepSeek-V3',
                        groupValue: appState.model,
                        onChanged:
                            (_) => Navigator.pop(
                              context,
                              'deepseek-ai/DeepSeek-V3',
                            ),
                      ),
                      Divider(),
                      RadioListTile(
                        title: Text('Qwen/QwQ-32B'),
                        value: 'Qwen/QwQ-32B',
                        groupValue: appState.model,
                        onChanged:
                            (_) => Navigator.pop(context, 'Qwen/QwQ-32B'),
                      ),
                      Divider(),
                      RadioListTile(
                        title: Text('internlm/internlm2_5-7b-chat'),
                        value: 'internlm/internlm2_5-7b-chat',
                        groupValue: appState.model,
                        onChanged:
                            (_) => Navigator.pop(
                              context,
                              'internlm/internlm2_5-7b-chat',
                            ),
                      ),
                      Divider(),
                      RadioListTile(
                        title: Text('THUDM/GLM-4-32B-0414'),
                        value: 'THUDM/GLM-4-32B-0414',
                        groupValue: appState.model,
                        onChanged:
                            (_) =>
                                Navigator.pop(context, 'THUDM/GLM-4-32B-0414'),
                      ),
                    ],
                  );
                },
              );
              if (model != null && model != appState.model) {
                await appState.setModel(model);
                appState.appBar = "Model: ${appState.model}";
              }
            },
            title: Text('Model'),
          ),
          ListTile(
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  var context0 = context;
                  return SimpleDialog(
                    title: Text('Clear'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          appState.clearHistory();
                          Navigator.of(context0).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('History'),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed: () {
                          appState.clearPrompt();
                          Navigator.of(context0).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Prompt'),
                      ),
                    ],
                  );
                },
              );
            },
            title: Text('Clear'),
          ),
          ListTile(
            onTap: () async {
              final themeNotifier = context.read<ThemeNotifier>();
              final currentMode = themeNotifier.themeMode;

              await showDialog(
                context: context,
                builder:
                    (context) => SimpleDialog(
                      title: const Text('Choose a theme'),
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('Light'),
                          value: ThemeMode.light,
                          groupValue: currentMode,
                          onChanged: (_) {
                            // themeNotifier.toggleTheme('light');
                            Provider.of<ThemeNotifier>(
                              context,
                              listen: false,
                            ).toggleTheme('light');
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          title: const Text('Dark'),
                          value: ThemeMode.dark,
                          groupValue: currentMode,
                          onChanged: (_) {
                            // themeNotifier.toggleTheme('dark');
                            Provider.of<ThemeNotifier>(
                              context,
                              listen: false,
                            ).toggleTheme('dark');
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          title: const Text('System'),
                          value: ThemeMode.system,
                          groupValue: currentMode,
                          onChanged: (_) {
                            // themeNotifier.toggleTheme('system');
                            Provider.of<ThemeNotifier>(
                              context,
                              listen: false,
                            ).toggleTheme('system');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
              );
            },
            title: const Text('Theme'),
          ),
          ListTile(
            onTap: () async {
              try {
                final pkgInfo = await PackageInfo.fromPlatform();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Version: ${pkgInfo.version}'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            },
            title: Text('Version'),
          ),
        ],
      ),
    );
  }
}
