import 'dart:async';
import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/components/grid.dart';
import 'package:portes_ouvertes/src/features/game/components/player.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';

class MyGame extends FlameGame {
  late Grid grid;
  late String gameId;
  List<Player> players = [];

  bool isPaused = false;

  void gameMerge(Game game) {
    for (PlayerModel player in game.players) {
      players.add(
        Player(
          id: player.uid,
          color: Color.fromARGB(
            255,
            player.uid.hashCode % 255,
            player.uid.hashCode % 123,
            player.uid.hashCode % 176,
          ),
          // position: player.position,
          position: Vector2(4, 4),
        ),
      );
    }

    // players.addAll([
    //   Player(id: 'p1', color: const Color(0xFF00FF00), position: Vector2(1, 1)),
    //   Player(id: 'p2', color: const Color(0xFFFF0000), position: Vector2(7, 7)),
    // ]);

    grid = Grid(sizeInCells: 9, cellSize: 54);
    add(grid);

    for (final player in players) {
      add(player);
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF101010);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

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

  // Highlight the Grid

  void highlightMoveZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.move;

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

  void highlightMeleeZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.melee;

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

    grid.highlightCells(neighbors);
  }

  void highlightShootZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.shoot;

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

    // for (int dx = -1; dx <= 1; dx++) {
    //   for (int dy = -1; dy <= 1; dy++) {
    //     addIfValid(gridPos.x + dx, gridPos.y + dy);
    //   }
    // }

    addIfValid(gridPos.x + 3, gridPos.y + 1);
    addIfValid(gridPos.x + 3, gridPos.y);
    addIfValid(gridPos.x + 3, gridPos.y - 1);

    addIfValid(gridPos.x - 3, gridPos.y + 1);
    addIfValid(gridPos.x - 3, gridPos.y);
    addIfValid(gridPos.x - 3, gridPos.y - 1);

    addIfValid(gridPos.x + 1, gridPos.y + 3);
    addIfValid(gridPos.x, gridPos.y + 3);
    addIfValid(gridPos.x - 1, gridPos.y + 3);

    addIfValid(gridPos.x + 1, gridPos.y - 3);
    addIfValid(gridPos.x, gridPos.y - 3);
    addIfValid(gridPos.x - 1, gridPos.y - 3);

    addIfValid(gridPos.x + 2, gridPos.y - 2);

    addIfValid(gridPos.x - 2, gridPos.y + 2);

    addIfValid(gridPos.x + 2, gridPos.y + 2);

    addIfValid(gridPos.x - 2, gridPos.y - 2);

    grid.highlightCells(neighbors);
  }

  void highlightBlockZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.block;

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

    addIfValid(gridPos.x, gridPos.y);

    grid.highlightCells(neighbors);
  }
}
