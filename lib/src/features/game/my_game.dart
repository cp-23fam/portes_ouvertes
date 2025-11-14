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

  static const playerColors = [
    0xffff4538,
    0xffffda38,
    0xff8fff38,
    0xff38ff77,
    0xff38f2ff,
    0xff385dff,
    0xffa838ff,
    0xffff38c0,
  ];

  void gameMerge(Game game) {
    grid = Grid(sizeInCells: 9, cellSize: 32.0);
    add(grid);

    for (PlayerModel player in game.players) {
      players.add(
        Player(
          id: player.uid,
          color: Color(playerColors[game.players.indexOf(player)]),
          lives: player.life,
          position: player.position,
        ),
      );
    }

    for (final player in players) {
      add(player);
    }

    text = TextComponent(
      text: '',
      position: Vector2(5.0, 3.0),
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
      }

      player.lives = playerModel.life;
    }

    grid.clearHighlights();
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
  Future<void> update(double dt) async {
    super.update(dt);

    if (status == GameStatus.choosing && players.length == 1) {
      print('Win scene');
    }

    if (status == GameStatus.choosing) {
      text.text =
          'Temps restant : ${((timestamp - DateTime.now().millisecondsSinceEpoch) / 1000.0).ceil()}s';
      if (timestamp < DateTime.now().millisecondsSinceEpoch) {
        final List<Vector2> dangerCells = await ref
            .read(gameRepositoryProvider)
            .playActions(gameId);
        grid.attackedCell = true;
        // grid.showShields()
        // for (Player player in players) {
        //   if (player.action == PlayerAction.block) {
        //     grid.showShield(player.position);
        //   }
        // }
        grid.highlightCells(dangerCells);
      }
    }

    if (status == GameStatus.showing) {
      text.text =
          'Prochain round : ${((timestamp - DateTime.now().millisecondsSinceEpoch) / 1000.0).ceil()}s';
      if (timestamp < DateTime.now().millisecondsSinceEpoch) {
        await ref.read(gameRepositoryProvider).nextRound(gameId);
        grid.clearHighlights();
        removeDeadPlayers();
      }
    }
  }

  void showActionOnPlayer(Vector2 cell, PlayerAction action) {}

  // Highlight the Grid

  void highlightMoveZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.move;
    grid.attackedCell = false;

    final Vector2 gridPos = Vector2(
      (player.position.x / player.cellSize).floorToDouble(),
      (player.position.y / player.cellSize).floorToDouble(),
    );

    final List<Vector2> neighbors = [];

    void addIfValid(double x, double y) {
      if (x >= 0.0 &&
          x < grid.sizeInCells &&
          y >= 0.0 &&
          y < grid.sizeInCells) {
        neighbors.add(Vector2(x, y));
      }
    }

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        addIfValid(gridPos.x + dx, gridPos.y + dy);
      }
    }

    addIfValid(gridPos.x + 2.0, gridPos.y);
    addIfValid(gridPos.x - 2.0, gridPos.y);
    addIfValid(gridPos.x, gridPos.y + 2.0);
    addIfValid(gridPos.x, gridPos.y - 2.0);

    grid.highlightCells(neighbors);
  }

  void highlightMeleeZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.melee;
    grid.attackedCell = true;

    final Vector2 gridPos = Vector2(
      (player.position.x / player.cellSize).floorToDouble(),
      (player.position.y / player.cellSize).floorToDouble(),
    );

    final List<Vector2> neighbors = [];

    void addIfValid(double x, double y) {
      if (x >= 0.0 &&
          x < grid.sizeInCells &&
          y >= 0.0 &&
          y < grid.sizeInCells) {
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
    grid.attackedCell = false;

    final Vector2 gridPos = Vector2(
      (player.position.x / player.cellSize).floorToDouble(),
      (player.position.y / player.cellSize).floorToDouble(),
    );

    final List<Vector2> neighbors = [];

    void addIfValid(double x, double y) {
      if (x >= 0.0 &&
          x < grid.sizeInCells &&
          y >= 0.0 &&
          y < grid.sizeInCells) {
        neighbors.add(Vector2(x, y));
      }
    }

    addIfValid(gridPos.x + 3.0, gridPos.y + 1.0);
    addIfValid(gridPos.x + 3.0, gridPos.y);
    addIfValid(gridPos.x + 3.0, gridPos.y - 1.0);

    addIfValid(gridPos.x - 3.0, gridPos.y + 1.0);
    addIfValid(gridPos.x - 3.0, gridPos.y);
    addIfValid(gridPos.x - 3.0, gridPos.y - 1.0);

    addIfValid(gridPos.x + 1.0, gridPos.y + 3.0);
    addIfValid(gridPos.x, gridPos.y + 3.0);
    addIfValid(gridPos.x - 1.0, gridPos.y + 3.0);

    addIfValid(gridPos.x + 1.0, gridPos.y - 3.0);
    addIfValid(gridPos.x, gridPos.y - 3.0);
    addIfValid(gridPos.x - 1.0, gridPos.y - 3.0);

    addIfValid(gridPos.x + 2.0, gridPos.y - 2.0);

    addIfValid(gridPos.x - 2.0, gridPos.y + 2.0);

    addIfValid(gridPos.x + 2.0, gridPos.y + 2.0);

    addIfValid(gridPos.x - 2.0, gridPos.y - 2.0);

    grid.highlightCells(neighbors);
  }

  void highlightBlockZone(String playerId) {
    final player = players.firstWhere((p) => p.id == playerId);
    grid.action = PlayerAction.block;
    grid.attackedCell = false;

    final Vector2 gridPos = Vector2(
      (player.position.x / player.cellSize).floorToDouble(),
      (player.position.y / player.cellSize).floorToDouble(),
    );

    grid.showShield(Vector2(gridPos.x, gridPos.y));
  }
}
