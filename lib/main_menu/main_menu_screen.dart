import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/wobbly_button.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                filterQuality: FilterQuality.none,
                height: 200,
              ),
              _gap,
              Transform.rotate(
                angle: 0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'Kaibigan, Tara, Laro Tayo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WobblyButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
              },
              child: const Text(
                'Play',
                style: TextStyle(color: Colors.white),
              ),
            ),
            _gap,
            WobblyButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleAudioOn(),
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            _gap,
            const Text(
              'by Allen James Alvaro, Bea Conag, Justin Gerald Loleng, and Hernani Domingo',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
