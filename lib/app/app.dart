import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appState.dart';
import '../pages/homePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'ChatBot',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(),
      ),
    );
  }
}
