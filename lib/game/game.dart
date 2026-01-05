import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:testLast-platformer-01/player.dart';
import 'package:testLast-platformer-01/level.dart';
import 'package:testLast-platformer-01/analytics_service.dart';
import 'package:testLast-platformer-01/game_controller.dart';
import 'package:testLast-platformer-01/ui_overlay.dart';

/// The main FlameGame class for the 'testLast-platformer-01' game.
class testLast-platformer-01Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState gameState = GameState.playing;

  /// The player component.
  late Player player;

  /// The current level.
  late Level currentLevel;

  /// The score.
  int score = 0;

  /// The number of lives.
  int lives = 3;

  /// The game controller.
  late GameController gameController;

  /// The analytics service.
  late AnalyticsService analyticsService;

  /// The UI overlay.
  late UIOverlay uiOverlay;

  @override
  Future<void> onLoad() async {
    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(480, 800));
    camera.followComponent(player);

    // Load the first level
    await loadLevel(1);

    // Set up the game controller and analytics service
    gameController = GameController(this);
    analyticsService = AnalyticsService();

    // Create the UI overlay
    uiOverlay = UIOverlay(this);
    overlays.add('ui', uiOverlay);
  }

  /// Loads the specified level.
  Future<void> loadLevel(int levelNumber) async {
    // Load the level data from the config
    currentLevel = await Level.load(levelNumber);

    // Add the level components to the game
    add(currentLevel);
    add(player = Player(currentLevel.startPosition));
  }

  /// Handles a tap input.
  @override
  void onTapDown(TapDownInfo info) {
    if (gameState == GameState.playing) {
      player.jump();
    }
  }

  /// Updates the game state and handles collisions.
  @override
  void update(double dt) {
    super.update(dt);

    // Handle collisions
    if (gameState == GameState.playing) {
      try {
        handleCollisions();
      } catch (e) {
        // Handle errors gracefully
        print('Error handling collisions: $e');
      }
    }

    // Update the game state
    switch (gameState) {
      case GameState.playing:
        // Update the player and level
        player.update(dt);
        currentLevel.update(dt);

        // Check for level completion
        if (currentLevel.isComplete) {
          gameState = GameState.levelComplete;
          analyticsService.logLevelComplete();
        }

        // Check for player death
        if (player.isDead) {
          gameState = GameState.gameOver;
          analyticsService.logLevelFail();
        }
        break;
      case GameState.levelComplete:
        // Handle level completion
        break;
      case GameState.gameOver:
        // Handle game over
        break;
      case GameState.paused:
        // Handle paused state
        break;
    }
  }

  /// Handles collisions between the player and level components.
  void handleCollisions() {
    // Check for collisions between the player and level components
    for (final component in currentLevel.children) {
      if (component is Collidable && player.collides(component)) {
        // Handle the collision
        component.onCollision(player);
      }
    }
  }
}

/// The game state enum.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}