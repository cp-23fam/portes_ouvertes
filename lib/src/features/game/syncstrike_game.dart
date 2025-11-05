import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/components/grid.dart';
import 'package:portes_ouvertes/src/features/game/components/player.dart';

class SyncstrikeGame extends FlameGame {
  late Grid grid;
  final List<Player> players = [];

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
        cellSize: 54,
      ),
      Player(
        id: 'p2',
        color: const Color(0xFFFF0000),
        position: Vector2(7, 7),
        cellSize: 54,
      ),
    ]);

    for (final player in players) {
      add(player);
    }
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
        // if (dx == 0 && dy == 0) continue;
        addIfValid(gridPos.x + dx, gridPos.y + dy);
      }
    }
    addIfValid(gridPos.x + 2, gridPos.y + 0);
    addIfValid(gridPos.x - 2, gridPos.y + 0);
    addIfValid(gridPos.x + 0, gridPos.y + 2);
    addIfValid(gridPos.x + 0, gridPos.y - 2);

    grid.highlightCells(neighbors);
  }
}
