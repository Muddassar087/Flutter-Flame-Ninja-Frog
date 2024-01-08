import 'package:flame/flame.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_2/data/level_storage.dart';
import 'package:flutter_game_2/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LevelsData.getSavedLevelProgress();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlameSplashScreen(
      onFinish: (ctx) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainMenu(),
            ));
      },
      theme: FlameSplashTheme.dark,
    );
  }
}
