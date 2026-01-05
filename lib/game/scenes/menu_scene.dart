import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the 'testLast-platformer-01' game.
class MenuScene extends Component with HasGameRef {
  /// The title of the game.
  final String gameTitle;

  /// The tagline of the game.
  final String gameTagline;

  /// The play button.
  late final Button playButton;

  /// The level select button.
  late final Button levelSelectButton;

  /// The settings button.
  late final Button settingsButton;

  /// The background animation.
  late final SpriteAnimation backgroundAnimation;

  /// Creates a new instance of the [MenuScene] class.
  MenuScene({
    required this.gameTitle,
    required this.gameTagline,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background animation
    backgroundAnimation = await gameRef.loadSpriteAnimation(
      'background.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2.all(128),
      ),
    );

    // Create the play button
    playButton = Button(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.6),
      size: Vector2(200, 60),
      text: 'Play',
      onPressed: () {
        // Navigate to the game scene
        gameRef.navigateTo(GameScene());
      },
    );
    add(playButton);

    // Create the level select button
    levelSelectButton = Button(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.7),
      size: Vector2(200, 60),
      text: 'Level Select',
      onPressed: () {
        // Navigate to the level select scene
        gameRef.navigateTo(LevelSelectScene());
      },
    );
    add(levelSelectButton);

    // Create the settings button
    settingsButton = Button(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.8),
      size: Vector2(200, 60),
      text: 'Settings',
      onPressed: () {
        // Navigate to the settings scene
        gameRef.navigateTo(SettingsScene());
      },
    );
    add(settingsButton);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render the background animation
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      Paint()..color = Colors.white,
    );
    backgroundAnimation.getSprite().render(canvas, position: Vector2.zero());

    // Render the game title and tagline
    final titleTextStyle = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final taglineTextStyle = TextStyle(
      fontSize: 24,
      color: Colors.white,
    );

    final titleTextPainter = TextPainter(
      text: TextSpan(
        text: gameTitle,
        style: titleTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    titleTextPainter.paint(
      canvas,
      Offset(
        gameRef.size.x / 2 - titleTextPainter.width / 2,
        gameRef.size.y * 0.2,
      ),
    );

    final taglineTextPainter = TextPainter(
      text: TextSpan(
        text: gameTagline,
        style: taglineTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    taglineTextPainter.paint(
      canvas,
      Offset(
        gameRef.size.x / 2 - taglineTextPainter.width / 2,
        gameRef.size.y * 0.3,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the background animation
    backgroundAnimation.update(dt);
  }
}