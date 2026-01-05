import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-platformer-01/player.dart';

/// Represents an obstacle in the platformer game.
class Obstacle extends PositionComponent with CollisionCallbacks {
  final Sprite _sprite;
  final double _speed;
  final double _damage;

  Obstacle({
    required Vector2 position,
    required this._sprite,
    required this._speed,
    required this._damage,
  }) : super(position: position, size: _sprite.originalSize) {
    anchor = Anchor.center;
  }

  @override
  void onMount() {
    super.onMount();
    priority = 1; // Ensure obstacles are rendered on top of other components
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt; // Move the obstacle horizontally

    // Wrap around the screen if the obstacle goes off-screen
    if (position.x < -width) {
      position.x = parent!.size.x + width;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      other.takeDamage(_damage);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }
}