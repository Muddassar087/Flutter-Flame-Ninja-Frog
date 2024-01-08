import 'package:flame/components.dart';
import 'package:flame/events.dart';

class PauseComponent extends RectangleComponent with TapCallbacks {
  PauseComponent({super.position, super.size, super.priority = 3}) {
    super.debugMode = false;
  }

  bool paused = false;

  @override
  void onTapDown(TapDownEvent event) {
    paused = true;
  }
}
