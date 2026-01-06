import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/game/game_logic.dart';
import 'package:memory_game/game/widgets/board.dart';
import 'package:memory_game/shared/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final GameLogic _game = GameLogic();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController =
  ConfettiController(duration: const Duration(seconds: 3));

  late Timer timer;
  int startTime = 60;
  int tries = 0;
  int score = 0;
  int highScore = 0;
  int complete = 0;

  bool _timerStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_timerStarted) {
      _game.initGame(context);
      _loadHighScore();
      _startTimer(context);
      _timerStarted = true;
    }
  }

  void _startTimer(BuildContext context) {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (startTime == 0) {
        timer.cancel();
        _endGame(context);
      } else {
        setState(() {
          startTime--;
        });
      }
    });
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', score);
  }

  void _endGame(BuildContext context) async {
    if (score > highScore) {
      await _saveHighScore();
      _confettiController.play();
    }

    _showDialog(
      context,
      'Fin de la partida',
      'Puntuación: $score\nRécord: ${score > highScore ? score : highScore}',
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: utils.redColor,
      appBar: AppBar(backgroundColor: utils.redColor),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  board('Time', '$startTime'),
                  board('Score', '$score'),
                  board('Moves', '$tries'),
                ],
              ),
              SizedBox(
                height: screenWidth,
                width: screenWidth,
                child: GridView.builder(
                  itemCount: _game.cardsImg!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _game.axiCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          tries++;
                          _game.cardsImg![index] =
                          _game.card_list[index];

                          _game.matchCheck
                              .add({index: _game.card_list[index]});

                          if (_game.matchCheck.length == 2) {
                            if (_game.matchCheck[0].values.first ==
                                _game.matchCheck[1].values.first) {
                              _audioPlayer.play(
                                AssetSource('sounds/match.mp3'),
                              );

                              score += 100;
                              complete++;
                              _game.matchCheck.clear();

                              if (complete * 2 == _game.cardCount) {
                                timer.cancel();
                                _endGame(context);
                              }
                            } else {
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                    () {
                                  setState(() {
                                    _game.cardsImg![_game.matchCheck[0].keys.first] =
                                        _game.hiddenCard;
                                    _game.cardsImg![_game.matchCheck[1].keys.first] =
                                        _game.hiddenCard;
                                    _game.matchCheck.clear();
                                  });
                                },
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: utils.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(_game.cardsImg![index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // 🎉 CONFETI
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String info) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(info),
        actions: [
          TextButton(
            child: const Text('Ir a inicio'),
            onPressed: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    timer.cancel();
    super.dispose();
  }
}