import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:testLast-platformer-01/game_objects/game_object.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent with HasGameRef<GameObjectsGame>, CollisionCallbacks {
  /// The player's current horizontal velocity.
  double xVelocity = 0;

  /// The player's current vertical velocity.
  double yVelocity = 0;

  /// The player's maximum horizontal speed.
  static const double maxHorizontalSpeed = 200;

  /// The player's maximum vertical speed.
  static const double maxVerticalSpeed = 500;

  /// The player's jump force.
  static const double jumpForce = -500;

  /// The player's health.
  int health = 3;

  /// The player's score.
  int score = 0;

  /// The player's animation states.
  late SpriteAnimation idleAnimation, walkingAnimation, jumpingAnimation;

  /// The current animation state.
  SpriteAnimation currentAnimation = SpriteAnimation.empty();

  /// The time since the last jump.
  TimerComponent jumpTimer = TimerComponent(0.25, repeat: false);

  /// Creates a new instance of the Player component.
  Player(Vector2 position) : super(position: position, size: Vector2.all(32)) {
    // Load the player's animations
    idleAnimation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('player_idle.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(32),
      ),
    );

    walkingAnimation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('player_walking.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );

    jumpingAnimation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('player_jumping.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(32),
      ),
    );

    // Set the initial animation state
    currentAnimation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's velocity and position
    xVelocity = (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowRight) ? maxHorizontalSpeed : 0) -
        (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowLeft) ? maxHorizontalSpeed : 0);
    yVelocity += 1500 * dt;
    yVelocity = yVelocity.clamp(-maxVerticalSpeed, maxVerticalSpeed);
    position.add(Vector2(xVelocity * dt, yVelocity * dt));

    // Update the player's animation state
    if (yVelocity < 0) {
      currentAnimation = jumpingAnimation;
    } else if (xVelocity.abs() > 0) {
      currentAnimation = walkingAnimation;
    } else {
      currentAnimation = idleAnimation;
    }

    // Update the jump timer
    jumpTimer.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Render the player's current animation
    currentAnimation.getSprite().render(canvas, position: position, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Handle player collisions
    if (other is Obstacle) {
      // Reduce player health on collision with an obstacle
      health--;
    } else if (other is Coin) {
      // Increase player score on collision with a coin
      score++;
      other.removeFromParent();
    }
  }

  /// Allows the player to jump if they are on the ground.
  void jump() {
    if (jumpTimer.isFinished) {
      yVelocity = jumpForce;
      jumpTimer.start();
    }
  }
}