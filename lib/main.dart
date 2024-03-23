import 'package:flutter/material.dart';
import 'package:flutter_memory_game/views/start_game_screen.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Game",
        primarySwatch: Colors.blue,
      ),
      home: const StartGameScreen(),
    );
  }
}
