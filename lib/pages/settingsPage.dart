import 'dart:ui';
import 'package:WBot/l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsAppBar)),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              return showDialog(
                context: context,
                builder: (content) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.prompt),
                    content: TextField(
                      controller: _promptContronller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.prompt,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.gotIt),
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
            title: Text(AppLocalizations.of(context)!.prompt),
          ),
          ListTile(
            onTap: () async {
              var model = await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(AppLocalizations.of(context)!.setModel),
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
                appState.appBar = model;
              }
            },
            title: Text(AppLocalizations.of(context)!.setModel),
          ),
          ListTile(
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (context) {
                  var context0 = context;
                  return SimpleDialog(
                    title: Text(AppLocalizations.of(context)!.clear),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          appState.clearHistory();
                          Navigator.of(context0).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.history),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed: () {
                          appState.clearPrompt();
                          Navigator.of(context0).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.prompt),
                      ),
                    ],
                  );
                },
              );
            },
            title: Text(AppLocalizations.of(context)!.clear),
          ),
          ListTile(
            onTap: () async {
              final themeNotifier = context.read<ThemeNotifier>();
              final currentMode = themeNotifier.themeMode;

              await showDialog(
                context: context,
                builder:
                    (context) => SimpleDialog(
                      title: Text(AppLocalizations.of(context)!.theme),
                      children: [
                        RadioListTile<ThemeMode>(
                          title: Text(AppLocalizations.of(context)!.lightTheme),
                          value: ThemeMode.light,
                          groupValue: currentMode,
                          onChanged: (_) {
                            Provider.of<ThemeNotifier>(
                              context,
                              listen: false,
                            ).toggleTheme('light');
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          title: Text(AppLocalizations.of(context)!.darkTheme),
                          value: ThemeMode.dark,
                          groupValue: currentMode,
                          onChanged: (_) {
                            Provider.of<ThemeNotifier>(
                              context,
                              listen: false,
                            ).toggleTheme('dark');
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        RadioListTile<ThemeMode>(
                          title: Text(
                            AppLocalizations.of(context)!.allowSystem,
                          ),
                          value: ThemeMode.system,
                          groupValue: currentMode,
                          onChanged: (_) {
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
            title: Text(AppLocalizations.of(context)!.theme),
          ),
          ListTile(
            onTap: () async {
              final localeNotifier = Provider.of<LocaleNotifier>(
                context,
                listen: false,
              );
              final currentLocale = localeNotifier.locale;

              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SimpleDialog(
                        title: Text(AppLocalizations.of(context)!.language),
                        children: [
                          RadioListTile<Locale>(
                            title: Text("Deutsch"),
                            value: const Locale('de'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text("English"),
                            value: const Locale('en'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text('Español'),
                            value: const Locale('es'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text('Français'),
                            value: const Locale('fr'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text('Русский'),
                            value: const Locale('ru'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text('한국어'),
                            value: const Locale('ko'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text('日本語'),
                            value: const Locale('ja'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text("中文(简体)"),
                            value: const Locale('zh'),
                            groupValue: currentLocale,
                            onChanged: (Locale? value) {
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<Locale>(
                            title: Text(
                              AppLocalizations.of(context)!.allowSystem,
                            ),
                            value: Locale(
                              PlatformDispatcher.instance.locale.languageCode,
                            ),
                            groupValue: currentLocale,
                            onChanged: (value) {
                              debugPrint("$value");
                              if (value != null) {
                                setState(() {
                                  localeNotifier.setLocale(value);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            title: Text(AppLocalizations.of(context)!.language),
          ),
          ListTile(
            onTap: () async {
              try {
                final pkgInfo = await PackageInfo.fromPlatform();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppLocalizations.of(context)!.version}: ${pkgInfo.version}',
                    ),
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
            title: Text(AppLocalizations.of(context)!.version),
          ),
        ],
      ),
    );
  }
}
