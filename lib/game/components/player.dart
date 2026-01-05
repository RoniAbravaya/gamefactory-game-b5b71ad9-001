import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-platformer-01/game_objects/obstacle.dart';
import 'package:testLast-platformer-01/game_objects/collectable.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const double _playerSpeed = 200.0;
  static const double _playerJumpForce = 500.0;
  static const double _playerGravity = 1200.0;

  double _velocityY = 0.0;
  double _health = 100.0;
  bool _isInvulnerable = false;
  double _invulnerabilityDuration = 2.0; // Seconds

  /// Constructs a new [Player] instance.
  Player(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(32.0),
          animation: SpriteAnimation.fromFrameData(
            Sprite('player.png'),
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.15,
              textureSize: Vector2.all(32.0),
            ),
          ),
        ) {
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    _velocityY += _playerGravity * dt;
    position.y += _velocityY * dt;

    // Handle invulnerability
    if (_isInvulnerable) {
      _invulnerabilityDuration -= dt;
      if (_invulnerabilityDuration <= 0) {
        _isInvulnerable = false;
      }
    }
  }

  /// Moves the player to the right.
  void moveRight() {
    position.x += _playerSpeed * game.dt;
  }

  /// Moves the player to the left.
  void moveLeft() {
    position.x -= _playerSpeed * game.dt;
  }

  /// Makes the player jump.
  void jump() {
    if (_velocityY.abs() < 0.1) {
      _velocityY = -_playerJumpForce;
    }
  }

  /// Handles collision with an [Obstacle].
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Obstacle) {
      _takeDamage(20);
    }
  }

  /// Handles collision with a [Collectable].
  @override
  void onCollisionEnd(Collidable other) {
    if (other is Collectable) {
      other.collect();
    }
  }

  /// Reduces the player's health by the specified amount.
  void _takeDamage(double amount) {
    if (!_isInvulnerable) {
      _health -= amount;
      _isInvulnerable = true;
      _invulnerabilityDuration = 2.0;
    }
  }

  /// Returns the player's current health.
  double get health => _health;
}