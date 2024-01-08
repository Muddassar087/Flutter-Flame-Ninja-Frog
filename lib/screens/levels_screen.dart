import 'package:flutter/material.dart';
import 'package:flutter_game_2/data/level_storage.dart';
import 'package:flutter_game_2/data/levels.dart' as level_data;
import 'package:flutter_game_2/screens/game.dart';

class LevelScreens extends StatelessWidget {
  const LevelScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LevelsData.getSavedLevelProgress(),
        builder: (context, snapShot) {
          return Scaffold(
            backgroundColor: const Color(0xff211F30),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Levels",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[400]!,
                  ),
                  const SizedBox(height: 16),
                  snapShot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: SizedBox(
                          width: 300,
                          child: ListView.builder(
                            itemCount: level_data.levels.length,
                            itemBuilder: (context, index) {
                              var e = level_data.levels[index];
                              return LevelCard(
                                text:
                                    "Level ${(index + 1).toString().padLeft(2, '0')}",
                                isLocked: e.isLocked,
                                onClick: () {
                                  LevelsData.updateActiveStatus(index);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          Game(
                                        activeLevelIndex: index,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ))
                ],
              ),
            ),
          );
        });
  }
}

class LevelCard extends StatelessWidget {
  const LevelCard(
      {super.key,
      this.isLocked = true,
      required this.text,
      required this.onClick});

  final bool isLocked;
  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? .5 : 1,
      child: GestureDetector(
        onTap: !isLocked ? onClick : null,
        child: Container(
          width: 300,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white),
              ),
              if (isLocked) const SizedBox(width: 12),
              if (isLocked)
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                )
            ],
          ),
        ),
      ),
    );
  }
}
