import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory_game/model/data.dart';
import 'package:flutter_memory_game/views/game_over_screen.dart';

class MyFlipCardGame extends StatefulWidget {
  const MyFlipCardGame({super.key});

  @override
  State<MyFlipCardGame> createState() => _MyFlipCardGameState();
}

class _MyFlipCardGameState extends State<MyFlipCardGame> {
  int _previousIndex = -1;
  int _time = 3;
  int gameDuration = -3;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  late bool _isFinished;
  late Timer _timer;
  late Timer _durationTimer;
  late int _left;
  late List _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _time = (_time - 1);
      });
    });
  }

  void startDuration() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        gameDuration = (gameDuration + 1);
      });
    });
  }

  void startGameAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        _timer.cancel();
      });
    });
  }

  void initializeGameData() {
    _data = createShuffledListFromImageSource();
    _cardFlips = getInitialItemStateList();
    _cardStateKeys = createFlipCardStateKeysList();
    _time = 3;
    _left = (_data.length ~/ 2);
    _isFinished = false;
  }

  @override
  void initState() {
    // inGameMusic.("ingame_bg.mp3");
    FlameAudio.bgm.play("ingame_bg.mp3");

    startTimer();
    startDuration();
    startGameAfterDelay();
    initializeGameData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _durationTimer.cancel();
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(_data[index])),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFinished
        ? GameOverScreen(
            duration: gameDuration,
          )
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/background_images/ingame_background.webp"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Remaining: $_left',
                          style: TextStyle(
                              fontFamily: "Game",
                              fontSize: 21,
                              color: Colors.yellow.shade700),
                        ),
                        Text(
                          'Duration: ${gameDuration}',
                          style: TextStyle(
                              fontFamily: "Game",
                              fontSize: 21,
                              color: Colors.yellow.shade700),
                        ),
                        Text(
                          'Countdown: $_time',
                          style: TextStyle(
                              fontFamily: "Game",
                              fontSize: 21,
                              color: Colors.yellow.shade700),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (context, index) => _start
                        ? FlipCard(
                            key: _cardStateKeys[index],
                            onFlip: () {
                              FlameAudio.play("flip.mp3");
                              if (!_flip) {
                                _flip = true;
                                _previousIndex = index;
                              } else {
                                _flip = false;
                                if (_previousIndex != index) {
                                  if (_data[_previousIndex] != _data[index]) {
                                    _wait = true;

                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      _cardStateKeys[_previousIndex]
                                          .currentState!
                                          .toggleCard();
                                      _previousIndex = index;
                                      _cardStateKeys[_previousIndex]
                                          .currentState!
                                          .toggleCard();

                                      Future.delayed(
                                          const Duration(milliseconds: 160),
                                          () {
                                        setState(() {
                                          _wait = false;
                                        });
                                      });
                                    });
                                  } else {
                                    _cardFlips[_previousIndex] = false;
                                    _cardFlips[index] = false;
                                    debugPrint("$_cardFlips");
                                    setState(() {
                                      _left -= 1;
                                    });
                                    if (_cardFlips.every((t) => t == false)) {
                                      debugPrint("Won");
                                      Future.delayed(
                                          const Duration(milliseconds: 160),
                                          () {
                                        setState(() {
                                          _isFinished = true;
                                          _start = false;
                                        });
                                        _durationTimer.cancel();
                                      });
                                    }
                                  }
                                }
                              }
                              setState(() {});
                            },
                            flipOnTouch: _wait ? false : _cardFlips[index],
                            direction: FlipDirection.HORIZONTAL,
                            front: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    "assets/images/image_cover.png",
                                  ),
                                ),
                              ),
                              margin: const EdgeInsets.all(4.0),
                            ),
                            back: getItem(index))
                        : getItem(index),
                    itemCount: _data.length,
                  ),
                ],
              ),
            ),
          );
  }
}
