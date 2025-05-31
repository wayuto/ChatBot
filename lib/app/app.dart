import 'dart:ui';
import 'package:WBot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:WBot/app/appState.dart';
import 'package:WBot/pages/homePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, child) {
        return ChangeNotifierProvider(
          create: (context) => MyAppState(),
          child: MaterialApp(
            title: 'WBot',
            debugShowCheckedModeBanner: false,
            locale: localeNotifier.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeNotifier.themeMode,
            home: const MyHomePage(),
          ),
        );
      },
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final theme = prefs.getString('theme') ?? 'system';
      _themeMode = _getThemeModeFromString(theme);
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(String theme) async {
    try {
      _themeMode = _getThemeModeFromString(theme);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', theme);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String theme) {
    return switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language');
      _locale =
          (languageCode != null)
              ? Locale(languageCode)
              : Locale(PlatformDispatcher.instance.locale.languageCode);
    } catch (e) {
      debugPrint('Error loading locale: $e');
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    try {
      _locale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', newLocale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
    notifyListeners();
  }
}
