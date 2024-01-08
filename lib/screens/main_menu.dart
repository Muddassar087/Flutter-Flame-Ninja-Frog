import 'package:flutter/material.dart';
import 'package:flutter_game_2/data/levels.dart' as levels_data;
import 'package:flutter_game_2/screens/game.dart';
import 'package:flutter_game_2/screens/levels_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff211F30),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Main menu",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white),
            ),
            Divider(
              color: Colors.grey[400]!,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Game(
                              activeLevelIndex: levels_data.levels
                                  .indexWhere((element) => element.isActive),
                            ),
                          ));
                    },
                    child: const Text("Start Game"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LevelScreens(),
                            ));
                      },
                      child: const Text("Levels")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
