import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart' hide Game;
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/game/components/grid.dart';
import 'package:portes_ouvertes/src/features/game/components/player.dart';
import 'package:portes_ouvertes/src/features/game/data/game_repository.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';

class MyGame extends FlameGame {
  MyGame({required this.ref});

  late Grid grid;
  late String gameId;
  List<Player> players = [];
  int timestamp = -1;
  final WidgetRef ref;
  GameStatus status = GameStatus.starting;

  bool isPaused = false;
  bool isInit = false;

  late TextComponent text;

  void gameMerge(Game game) {
    grid = Grid(sizeInCells: 9, cellSize: 54);
    add(grid);

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
          lives: player.life,
          position: player.position,
          // position: Vector2(4, 4),
        ),
      );
    }

    // players.addAll([
    //   Player(id: 'p1', color: const Color(0xFF00FF00), position: Vector2(1, 1)),
    //   Player(id: 'p2', color: const Color(0xFFFF0000), position: Vector2(7, 7)),
    // ]);

    for (final player in players) {
      add(player);
    }

    text = TextComponent(
      text: '',
      position: Vector2(5, 3),
      textRenderer: TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 18.0),
      ),
    );

    add(text);
  }

  void gameUpdatePlayers(Game game) {
    for (PlayerModel playerModel in game.players) {
      final player = getPlayerById(playerModel.uid);

      if (playerModel.action == PlayerAction.move) {
        player.moveToCell(playerModel.actionPos!);
        // if (playerModel.actionPos != null) {
        //   player.moveToCell(playerModel.actionPos!);
        // }
      }

      player.lives = playerModel.life;
    }

    grid.clearHighlights();

    // executeRoundEnd();
  }

  void removeDeadPlayers() {
    for (Player player in players.where((p) => p.lives < 1)) {
      remove(player);
      players.remove(player);
    }
  }

  Player getPlayerById(String id) {
    return players.firstWhere((p) => p.id == id);
  }

  @override
  Color backgroundColor() => const Color(0xFF101010);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // startRound();
  }

  // void startRound() {
  //   isPaused = false;
  // }

  // void pauseRound() {
  //   isPaused = true;
  //   Future.delayed(const Duration(seconds: 5), () {
  //     startRound();
  //   });
  // }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (status == GameStatus.choosing && players.length == 1) {
      print('Win scene');
    }

    if (status == GameStatus.choosing) {
      text.text =
          'Temps restant : ${((timestamp - DateTime.now().millisecondsSinceEpoch) / 1000).ceil()}s';
      if (timestamp < DateTime.now().millisecondsSinceEpoch) {
        final List<Vector2> dangerCells = await ref
            .read(gameRepositoryProvider)
            .playActions(gameId);
        grid.highlightCells(dangerCells);
        // gameUpdatePlayers();
      }
    }

    if (status == GameStatus.showing) {
      text.text =
          'Prochain round : ${((timestamp - DateTime.now().millisecondsSinceEpoch) / 1000).ceil()}s';
      if (timestamp < DateTime.now().millisecondsSinceEpoch) {
        await ref.read(gameRepositoryProvider).nextRound(gameId);
        grid.clearHighlights();
        removeDeadPlayers();
      }

      // print(
      //   'Showing Timer : ${(timestamp - DateTime.now().millisecondsSinceEpoch) / 1000}',
      // );
    }
  }

  Future<void> executeRoundEnd() async {
    grid.clearHighlights();
    // pauseRound();
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
        if (dy == 0 && dx == 0) {
          continue;
        }

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
