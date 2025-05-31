import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wbot/app/app.dart';
import 'package:wbot/app/appState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeNotifier = ThemeNotifier();
  final localeNotifier = LocaleNotifier();

  await Future.wait([themeNotifier.loadTheme(), localeNotifier.loadLocale()]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeNotifier),
        ChangeNotifierProvider.value(value: localeNotifier),
        ChangeNotifierProvider(create: (context) => MyAppState()),
      ],
      child: const MyApp(),
    ),
  );
}
