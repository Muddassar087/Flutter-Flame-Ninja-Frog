import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game_2/pixel_adventure.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(position: position, priority: -1);

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache("Background/$color.png"));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;

    double tileSize = 64;

    int numTilesY = ((game.size.y) / tileSize).floor();

    if (position.y > numTilesY * tileSize) position.y = -tileSize;
  }
}
