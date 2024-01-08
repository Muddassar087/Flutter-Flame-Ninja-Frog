import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    super.position,
    super.size,
    this.platform = false,
  }) {
    super.debugMode = false;
  }

  bool platform;
}
