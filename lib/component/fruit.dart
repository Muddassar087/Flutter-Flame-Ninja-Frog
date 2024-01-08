import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game_2/component/custom_hitbox.dart';
import 'package:flutter_game_2/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = "Apple",
    super.position,
    super.size,
  });

  final double stepTime = .05;
  bool collected = false;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      size: Vector2(
        hitbox.width,
        hitbox.height,
      ),
      position: Vector2(
        hitbox.offsetX,
        hitbox.offsetY,
      ),
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Items/Fruits/$fruit.png"),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void collidedWithPlayer() {
    if (!collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Items/Fruits/Collected.png"),
        SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: stepTime,
            textureSize: Vector2.all(32),
            loop: false),
      );
      collected = true;
    }

    Future.delayed(const Duration(milliseconds: 400), () => removeFromParent());
  }
}
