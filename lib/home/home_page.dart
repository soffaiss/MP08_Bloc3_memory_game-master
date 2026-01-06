import 'package:flutter/material.dart';
import 'package:memory_game/shared/utils.dart' as utils;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.blueColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.question_mark_rounded),
              onPressed: () {
                Navigator.pushNamed(context, 'info');
              },
            ),
          ),
        ],
        backgroundColor: utils.blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Image(
                image: AssetImage('assets/images/Memories.png'),
              ),
              const SizedBox(height: 20),

              // NIVEL FÁCIL
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'intermedia',
                    arguments: {'level': 'easy'},
                  );
                },
                child: const Text(
                  'Fácil',
                  style: TextStyle(
                    color: utils.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // NIVEL MEDIO
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'intermedia',
                    arguments: {'level': 'medium'},
                  );
                },
                child: const Text(
                  'Medio',
                  style: TextStyle(
                    color: utils.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // NIVEL DIFÍCIL
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'intermedia',
                    arguments: {'level': 'hard'},
                  );
                },
                child: const Text(
                  'Difícil',
                  style: TextStyle(
                    color: utils.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}