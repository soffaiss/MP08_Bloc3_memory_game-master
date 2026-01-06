import 'package:flutter/material.dart';
import 'package:memory_game/shared/utils.dart' as utils;

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map arguments =
    ModalRoute.of(context)!.settings.arguments as Map;

    final String level = arguments['level'];

    return Scaffold(
      backgroundColor: utils.blueColor,
      appBar: AppBar(
        backgroundColor: utils.blueColor,
        title: const Text('Selecciona temàtica'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            _themeButton(context, 'Animals', 'animals', level),
            const SizedBox(height: 20),

            _themeButton(context, 'Esports', 'sports', level),
            const SizedBox(height: 20),

            _themeButton(context, 'Videojocs', 'games', level),
          ],
        ),
      ),
    );
  }

  Widget _themeButton(
      BuildContext context,
      String text,
      String theme,
      String level,
      ) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          'game',
          arguments: {
            'level': level,
            'theme': theme,
          },
        );
      },
      child: Text(
        text,
        style: const TextStyle(
          color: utils.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
