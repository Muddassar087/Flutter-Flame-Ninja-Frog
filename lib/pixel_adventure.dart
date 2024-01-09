import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_2/component/jump_component.dart';
import 'package:flutter_game_2/component/pause_menu.dart';
import 'package:flutter_game_2/data/level_storage.dart';
import 'package:flutter_game_2/data/levels.dart' as level_data;
import 'package:flutter_game_2/levels/level_0.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapDetector {
  PixelAdventure({
    this.currentIndex = 0,
  });

  Function(int)? activateStatus;
  CameraComponent? cameraComponent;
  Level? level;
  late JoystickComponent joystickComponent;
  late JumpComponent jumpComponent;
  late PauseComponent pauseComponent;
  late int currentIndex;

  @override
  Color backgroundColor() => const Color(0xff211f30);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final knobPaint = BasicPalette.white.withAlpha(100).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(50).paint();

    joystickComponent = JoystickComponent(
        knob: CircleComponent(radius: 20, paint: knobPaint),
        background: CircleComponent(radius: 30, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
        priority: 3);

    jumpComponent = JumpComponent(
      radius: 24,
      position: Vector2(size.x - 88, size.y - 88),
      paint: Paint()..color = Colors.white.withOpacity(.5),
      priority: 3,
    );

    pauseComponent = PauseComponent(
      text: "Pause",
      position: Vector2(30, 10),
      size: Vector2(10, 10),
    );

    loadLevel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (pauseComponent.paused) {
      overlays.add('PauseMenu');
      pauseEngine();
    }

    super.update(dt);
  }

  void loadLevel() {
    if (cameraComponent != null) {
      removeAll([cameraComponent!, level!]);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      level = Level(
          levelUrl: level_data.levels[currentIndex].name,
          joystickComponent: joystickComponent,
          jumpComponent: jumpComponent)
        ..priority = 1;

      cameraComponent = CameraComponent.withFixedResolution(
        world: level,
        width: 640,
        height: 360,
      )
        ..viewfinder.anchor = Anchor.topLeft
        ..priority = 2;

      addAll([
        joystickComponent,
        jumpComponent,
        cameraComponent!,
        level!,
        pauseComponent
      ]);
    });
  }

  void loadNextLevel() async {
    if (currentIndex >= level_data.levels.length - 1) {
      currentIndex = 0;
    } else {
      currentIndex++;
    }

    await LevelsData.unlockAndActivate(currentIndex);

    loadLevel();
  }
}
