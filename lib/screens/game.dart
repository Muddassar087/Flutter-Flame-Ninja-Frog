import 'package:flame/game.dart';
import 'package:flutter_game_2/pixel_adventure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_2/screens/main_menu.dart';

class Game extends StatelessWidget {
  const Game({
    super.key,
    this.activeLevelIndex = 0,
  });

  final int activeLevelIndex;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: PixelAdventure(
        currentIndex: activeLevelIndex,
      ),
      overlayBuilderMap: {
        'PauseMenu': (ctx, _) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.black.withOpacity(
              .35,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Paused',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const MainMenu(),
                          ));
                    },
                    child: const Text("Go to main menu"),
                  ),
                ],
              ),
            ),
          );
        },
      },
    );
  }
}
