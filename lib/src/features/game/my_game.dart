import 'dart:async';
import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/components/grid.dart';
import 'package:portes_ouvertes/src/features/game/components/player.dart';
import 'package:portes_ouvertes/src/features/game/data/game_repository.dart';

class MyGame extends FlameGame {
  late Grid grid;
  late String gameId;
  List<Player> players = [];

  bool isPaused = false;

  @override
  Color backgroundColor() => const Color(0xFF101010);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    grid = Grid(sizeInCells: 9, cellSize: 54);
    add(grid);

    players.addAll([
      Player(
        id: 'p1',
        color: const Color(0xFF00FF00),
        position: Vector2(1, 1),
        // cellSize: 54,
      ),
      Player(
        id: 'p2',
        color: const Color(0xFFFF0000),
        position: Vector2(7, 7),
        // cellSize: 54,
      ),
    ]);

    for (final player in players) {
      add(player);
    }

    gameId = await GameRepository().startGame(['p1', 'p2']);

    startRound();
  }

  void startRound() {
    isPaused = false;
  }

  void pauseRound() {
    isPaused = true;
    Future.delayed(const Duration(seconds: 5), () {
      startRound();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    // ------------- Lecture du Stream ------------- \\
  }

  Future<void> executeRoundEnd() async {
    // ------------- Réccuperation ------------- \\

    // Game repoGame = await GameRepository().fetchGame(gameId);
    // // players = repoGame.players;

    // for (Player player in players) {
    //   PlayerModel repoPlayer = repoGame.players.firstWhere(
    //     (p) => p.uid == player.id,
    //   );

    //   player.action = repoPlayer.action;
    //   // player.target = repoPlayer.target;
    //   player.position = repoPlayer.position;
    // }

    grid.clearHighlights();
    pauseRound();
  }

  void highlightMoveZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);

    final Vector2 gridPos = Vector2(
      (player.position.x / player.cellSize).floorToDouble(),
      (player.position.y / player.cellSize).floorToDouble(),
    );

    final List<Vector2> neighbors = [];

    void addIfValid(double x, double y) {
      if (x >= 0 && x < grid.sizeInCells && y >= 0 && y < grid.sizeInCells) {
        neighbors.add(Vector2(x, y));
      }
    }

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        addIfValid(gridPos.x + dx, gridPos.y + dy);
      }
    }

    addIfValid(gridPos.x + 2, gridPos.y);
    addIfValid(gridPos.x - 2, gridPos.y);
    addIfValid(gridPos.x, gridPos.y + 2);
    addIfValid(gridPos.x, gridPos.y - 2);

    grid.highlightCells(neighbors);
  }
}

// class MyGame extends FlameGame {
//   late Grid grid;
//   late String gameId;
//   List<Player> players = [];

//   DateTime? roundTimer;
//   bool isPaused = false;

//   final ValueNotifier<int> remainingTime = ValueNotifier<int>(0);

//   @override
//   Color backgroundColor() => const Color(0xFF101010);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     grid = Grid(sizeInCells: 9, cellSize: 54);
//     add(grid);

//     players.addAll([
//       Player(
//         id: 'p1',
//         color: const Color(0xFF00FF00),
//         position: Vector2(1, 1),
//         // cellSize: 54,
//       ),
//       Player(
//         id: 'p2',
//         color: const Color(0xFFFF0000),
//         position: Vector2(7, 7),
//         // cellSize: 54,
//       ),
//     ]);

//     for (final player in players) {
//       add(player);
//     }

//     gameId = await GameRepository().startGame(['p1', 'p2']);

//     startRound();
//   }

//   void startRound() {
//     isPaused = false;
//     roundTimer = DateTime.now().add(const Duration(seconds: 20));
//   }

//   void pauseRound() {
//     isPaused = true;
//     Future.delayed(const Duration(seconds: 5), () {
//       startRound();
//     });
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     if (roundTimer != null && !isPaused) {
//       final now = DateTime.now();
//       final diff = roundTimer!.difference(now).inSeconds;

//       if (diff >= 0) {
//         remainingTime.value = diff;
//       }

//       if (now.isAfter(roundTimer!)) {
//         executeRoundEnd();
//       }
//     }
//   }

//   Future<void> executeRoundEnd() async {
//     Game repoGame = await GameRepository().fetchGame(gameId);
//     // players = repoGame.players;

//     for (Player player in players) {
//       PlayerModel repoPlayer = repoGame.players.firstWhere(
//         (p) => p.uid == player.id,
//       );

//       player.action = repoPlayer.action;
//       // player.target = repoPlayer.target;
//       player.position = repoPlayer.position;
//     }

//     grid.clearHighlights();
//     pauseRound();
//   }

//   void highlightMoveZone(String playerId) {
//     final player = players.firstWhere((p) => p.id == playerId);

//     final Vector2 gridPos = Vector2(
//       (player.position.x / player.cellSize).floorToDouble(),
//       (player.position.y / player.cellSize).floorToDouble(),
//     );

//     final List<Vector2> neighbors = [];

//     void addIfValid(double x, double y) {
//       if (x >= 0 && x < grid.sizeInCells && y >= 0 && y < grid.sizeInCells) {
//         neighbors.add(Vector2(x, y));
//       }
//     }

//     for (int dx = -1; dx <= 1; dx++) {
//       for (int dy = -1; dy <= 1; dy++) {
//         addIfValid(gridPos.x + dx, gridPos.y + dy);
//       }
//     }

//     addIfValid(gridPos.x + 2, gridPos.y);
//     addIfValid(gridPos.x - 2, gridPos.y);
//     addIfValid(gridPos.x, gridPos.y + 2);
//     addIfValid(gridPos.x, gridPos.y - 2);

//     grid.highlightCells(neighbors);
//   }
// }
