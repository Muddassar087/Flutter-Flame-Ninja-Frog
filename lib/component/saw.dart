import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game_2/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Saw({
    super.position,
    super.size,
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
  });

  final bool isVertical;
  final double offNeg;
  final double offPos;

  static const double sawSpeed = 0.03;
  static const moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox());

    if (isVertical) {
      rangePos = position.y + offPos * tileSize;
      rangeNeg = position.y - offNeg * tileSize;
    } else {
      rangePos = position.x + offPos * tileSize;
      rangeNeg = position.x - offNeg * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Traps/Saw/On (38x38).png"),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.03,
        textureSize: Vector2.all(38),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      moveVertical(dt);
    } else {
      moveHorizontal(dt);
    }
    super.update(dt);
  }

  void moveVertical(double dt) {
    if (position.y > rangePos) {
      moveDirection = -1;
    } else if (position.y < rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void moveHorizontal(double dt) {
    if (position.x > rangePos) {
      moveDirection = -1;
    } else if (position.x < rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
