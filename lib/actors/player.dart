import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_2/component/checkpoint.dart';
import 'package:flutter_game_2/component/collision_block.dart';
import 'package:flutter_game_2/component/custom_hitbox.dart';
import 'package:flutter_game_2/component/fruit.dart';
import 'package:flutter_game_2/component/jump_component.dart';
import 'package:flutter_game_2/component/saw.dart';
import 'package:flutter_game_2/component/utils.dart';
import 'package:flutter_game_2/pixel_adventure.dart';

enum PlayerAnimation {
  idle,
  running,
  falling,
  jumping,
  reSpawn,
  appearing,
}

enum PlayerDirection { right, left, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.characterUrl,
    required this.joystickComponent,
    required this.jumpComp,
  }) : super(priority: 1);

  String characterUrl;
  final JoystickComponent joystickComponent;
  final JumpComponent jumpComp;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation reSpawnAnimation;
  late final SpriteAnimation appearingAnimation;
  final double stepTime = 0.05;
  bool isFacingRight = true;
  bool hasJumped = false;
  bool isOnGround = true;
  double horizontalMovement = 0;
  bool reachedCheckpoint = false;

  bool hit = false;

  PlayerDirection playerDirection = PlayerDirection.none;

  double speed = 100;
  Vector2 velocity = Vector2.zero();

  Vector2? initiailPostion;

  List<CollisionBlock> collsionBlocks = [];

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  final double gravity = 9.8;
  final double jumpForce = 360;
  final double terminalForce = 300;

  @override
  void update(double dt) {
    if (!hit && !reachedCheckpoint) {
      updateByJoyStick();
      jumpByButton();
      _movePlayer(dt);
      _updatePlayerState();
      _checkHorizontalCollision();
      _applyGravity(dt);
      _checkVerticalCollison();
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    initiailPostion = Vector2(position.x, position.y);
    _loadAllAnimations();
    add(
      RectangleHitbox(
        position: Vector2(
          hitbox.offsetX,
          hitbox.offsetY,
        ),
        size: Vector2(
          hitbox.width,
          hitbox.height,
        ),
      ),
    );
    // debugMode = true;
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw) onCollidedWithSaw();
      if (other is CheckPoint) _reachedCheckpoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void jumpByButton() {
    hasJumped = jumpComp.isJumped;
  }

  void updateByJoyStick() {
    if (joystickComponent.direction == JoystickDirection.right ||
        joystickComponent.direction == JoystickDirection.upRight ||
        joystickComponent.direction == JoystickDirection.downRight) {
      horizontalMovement = 1;
    } else if (joystickComponent.direction == JoystickDirection.left ||
        joystickComponent.direction == JoystickDirection.upLeft ||
        joystickComponent.direction == JoystickDirection.downLeft) {
      horizontalMovement = -1;
    } else {
      horizontalMovement = 0;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerState() {
    PlayerAnimation playerState = PlayerAnimation.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerAnimation.running;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerAnimation.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerAnimation.jumping;

    current = playerState;
  }

  _loadAllAnimations() {
    runningAnimation = _getAnimation(state: "Run", amount: 12);
    idleAnimation = _getAnimation(state: "Idle", amount: 11);
    jumpingAnimation = _getAnimation(state: "Jump", amount: 1);
    fallingAnimation = _getAnimation(state: "Fall", amount: 1);
    reSpawnAnimation = _getAnimation(amount: 7, state: "Hit");
    appearingAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/Appearing (96x96).png"),
      SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: stepTime,
          textureSize: Vector2.all(96),
          loop: true),
    );

    animations = {
      PlayerAnimation.idle: idleAnimation,
      PlayerAnimation.running: runningAnimation,
      PlayerAnimation.jumping: jumpingAnimation,
      PlayerAnimation.falling: fallingAnimation,
      PlayerAnimation.reSpawn: reSpawnAnimation,
      PlayerAnimation.appearing: appearingAnimation,
    };

    current = PlayerAnimation.idle;
  }

  SpriteAnimation _getAnimation({required amount, required state}) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache("Main Characters/$characterUrl/$state (32x32).png"),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }

  _movePlayer(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * speed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  _checkHorizontalCollision() {
    for (var block in collsionBlocks) {
      if (!block.platform) {
        if (checkCollision(this, block)) {
          // Right Collison
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - (hitbox.width + hitbox.offsetX);
          }
          // Left collision
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x =
                (block.x + block.width) + (hitbox.offsetX + hitbox.width);
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(-jumpForce, terminalForce);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollison() {
    for (var block in collsionBlocks) {
      if (block.platform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }

          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }

  onCollidedWithSaw() {
    hit = true;
    current = PlayerAnimation.reSpawn;
    Future.delayed(const Duration(milliseconds: 350), () {
      scale.x = 1;
      current = PlayerAnimation.appearing;
      position = (initiailPostion! - Vector2.all(32));
      Future.delayed(const Duration(milliseconds: 350), () {
        position = (initiailPostion!);
        _updatePlayerState();
        hit = false;
      });
    });
  }

  void _reachedCheckpoint() async {
    reachedCheckpoint = true;
    current = PlayerAnimation.appearing;

    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    Future.delayed(const Duration(milliseconds: 350), () {
      reachedCheckpoint = false;
      position = Vector2.all(-640);

      const waitToChangeDuration = Duration(seconds: 3);
      Future.delayed(waitToChangeDuration, () => game.loadNextLevel());
    });
  }
}
