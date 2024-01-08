import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game_2/actors/player.dart';
import 'package:flutter_game_2/component/background_tile.dart';
import 'package:flutter_game_2/component/checkpoint.dart';
import 'package:flutter_game_2/component/collision_block.dart';
import 'package:flutter_game_2/component/fruit.dart';
import 'package:flutter_game_2/component/jump_component.dart';
import 'package:flutter_game_2/component/saw.dart';
import 'package:flutter_game_2/pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  Level({
    required this.levelUrl,
    required this.joystickComponent,
    required this.jumpComponent,
  });

  late TiledComponent level;
  late Player player1;
  final String levelUrl;
  final JoystickComponent joystickComponent;
  final JumpComponent jumpComponent;

  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      "$levelUrl.tmx",
      Vector2(16, 16),
    );

    _swapnObjects();
    _addCollision();
    _scrollingBackground();

    add(level);

    return super.onLoad();
  }

  void _addCollision() {
    var collisions = level.tileMap.getLayer<ObjectGroup>("Collisions");

    if (collisions != null) {
      for (var collision in collisions.objects) {
        if (collision.class_ == "Platform") {
          var platform = CollisionBlock(
            platform: true,
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(platform);
          collisionBlocks.add(platform);
        } else if (collision.class_ == "collision") {
          var c = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(
              collision.width,
              collision.height,
            ),
          );

          add(c);
          collisionBlocks.add(c);
        }
      }

      player1.collsionBlocks = collisionBlocks;
    }
  }

  void _swapnObjects() {
    var spawnPoints = level.tileMap.getLayer<ObjectGroup>("Spawnpoints");
    if (spawnPoints?.objects != null) {
      for (var objects in spawnPoints!.objects) {
        if (objects.class_ == "Player") {
          player1 = Player(
            characterUrl: "Ninja Frog",
            joystickComponent: joystickComponent,
            jumpComp: jumpComponent,
          )..position = Vector2(objects.x, objects.y);
          add(player1);
        } else if (objects.class_ == "Fruit") {
          final fruit = Fruit(fruit: objects.name)
            ..position = Vector2(objects.x, objects.y)
            ..size = Vector2.all(32);

          add(fruit);
        } else if (objects.class_ == "Saw") {
          final isVertical = objects.properties.getValue("isVertical");
          final offsetPos = objects.properties.getValue("offsetPos");
          final offsetNeg = objects.properties.getValue("offsetNeg");

          final saw = Saw(
            isVertical: isVertical,
            offNeg: offsetNeg,
            offPos: offsetPos,
          )
            ..position = Vector2(objects.x, objects.y)
            ..size = Vector2.all(32);

          add(saw);
        } else if (objects.class_ == "checkpoint") {
          final checkPoint = CheckPoint(
              size: Vector2.all(64), position: Vector2(objects.x, objects.y));
          add(checkPoint);
        }
      }
    }
  }

  _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer("background");
    var tileSize = 64;

    int numTilesY = ((game.size.y) / tileSize).floor();
    int numTilesX = ((game.size.x) / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue("BackgroundColor");

      for (int y = 0; y < (game.size.y / numTilesY).floor(); y++) {
        for (int x = 0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? "Gray",
            position:
                Vector2((x * tileSize).toDouble(), (y * tileSize).toDouble()),
          );
          add(backgroundTile);
        }
      }
    }
  }
}
