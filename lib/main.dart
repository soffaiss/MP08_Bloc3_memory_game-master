import 'package:flutter/material.dart';

import 'game/game.dart';
import 'home/home_page.dart';
import 'info/info_page.dart';
import 'intermedia/intermedia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      home: HomePage(),
      routes: {
        'home': (context) => const HomePage(),
        'intermedia': (context) => const ThemePage(),
        'game': (context) => Game(),
        'info': (context) => const InfoPage(),
      },
    );
  }
}
