import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// A collectible item that can be picked up by the player.
class Collectible extends SpriteComponent with HasGameRef {
  /// The score value of the collectible.
  final int scoreValue;

  /// The audio player for the collection sound effect.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// The sprite animation for the collectible.
  late final SpriteAnimation _animation;

  /// Creates a new instance of the [Collectible] component.
  ///
  /// [sprite] is the sprite for the collectible.
  /// [scoreValue] is the score value of the collectible.
  Collectible({
    required Sprite sprite,
    required this.scoreValue,
  }) : super(
          size: Vector2.all(32.0),
          sprite: sprite,
        ) {
    _setupAnimation();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(
      gameRef.size.x / 2,
      gameRef.size.y / 2,
    );

    // Add a collision box to the collectible
    add(RectangleHitbox());

    // Add a spinning effect to the collectible
    add(RotateEffect.by(
      360 * 2,
      EffectController(
        duration: 2,
        infinite: true,
      ),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Check if the other component is the player
    if (other is Player) {
      // Increase the player's score
      other.score += scoreValue;

      // Play the collection sound effect
      _audioPlayer.play(AssetSource('collect_sound.mp3'));

      // Remove the collectible from the game
      removeFromParent();
    }
  }

  void _setupAnimation() {
    final spriteSheet = SpriteSheet(
      image: Image.asset('collectible_sprite_sheet.png'),
      srcSize: Vector2.all(32.0),
    );

    _animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.2,
      to: 4,
    );

    sprite = _animation.getSprite(0);
  }
}