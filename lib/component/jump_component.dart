import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JumpComponent extends CircleComponent with TapCallbacks {
  JumpComponent({
    super.position,
    super.priority,
    super.radius,
    super.paint,
  });

  bool isJumped = false;

  @override
  void onTapDown(TapDownEvent event) {
    isJumped = true;
    Future.delayed(const Duration(milliseconds: 50), () {
      isJumped = false;
    });
  }
}
