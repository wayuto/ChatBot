import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}
