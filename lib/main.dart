import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wbot/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();
  runApp(
    ChangeNotifierProvider.value(value: themeNotifier, child: const MyApp()),
  );
}
