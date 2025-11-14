import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';

class Grid extends PositionComponent with TapCallbacks {
  Grid({required this.sizeInCells, required this.cellSize}) {
    size = Vector2(sizeInCells * cellSize, sizeInCells * cellSize);
    anchor = Anchor.topLeft;
    position = Vector2.zero();
  }

  final int sizeInCells;
  final double cellSize;
  final List<Vector2> highlightedCells = [];
  final List<Vector2> shields = [];
  PlayerAction action = PlayerAction.none;
  Vector2? selectedCell;
  bool attackedCell = false;

  void highlightCells(List<Vector2> cells) {
    highlightedCells
      ..clear()
      ..addAll(cells);
    selectedCell = null;
    shields.clear();
  }

  void clearHighlights() {
    highlightedCells.clear();
    shields.clear();
    selectedCell = null;
  }

  void showShield(Vector2 cell) {
    highlightedCells.clear();
    shields
      ..clear()
      ..add(cell);
    selectedCell = null;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (action == PlayerAction.move) {
      final local = event.localPosition;
      final cell = Vector2(
        (local.x / cellSize).floorToDouble(),
        (local.y / cellSize).floorToDouble(),
      );

      if (highlightedCells.any((c) => c.x == cell.x && c.y == cell.y)) {
        selectedCell = cell;
      } else {
        selectedCell = null;
      }
    } else if (action == PlayerAction.shoot) {
      final local = event.localPosition;
      final cell = Vector2(
        (local.x / cellSize).floorToDouble(),
        (local.y / cellSize).floorToDouble(),
      );

      if (highlightedCells.any((c) => c.x == cell.x && c.y == cell.y)) {
        selectedCell = cell;
      } else {
        selectedCell = null;
      }
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
    final highlightPaint = Paint()
      ..color = Colors.grey.shade400.withAlpha(100)
      ..style = PaintingStyle.fill;
    final selectedPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final attackPaint = Paint()
      ..color = Colors.redAccent.withAlpha(100)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
    final shieldPaint = Paint()
      ..color = Colors.blueAccent.withAlpha(100)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    for (int i = 0; i <= sizeInCells; i++) {
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(sizeInCells * cellSize, i * cellSize),
        paint,
      );
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, sizeInCells * cellSize),
        paint,
      );
    }

    for (final cell in highlightedCells) {
      if (cell.x < 0 ||
          cell.x >= sizeInCells ||
          cell.y < 0 ||
          cell.y >= sizeInCells) {
        continue;
      }

      canvas.drawRect(
        Rect.fromLTWH(cell.x * cellSize, cell.y * cellSize, cellSize, cellSize),
        attackedCell ? attackPaint : highlightPaint,
      );
    }

    if (selectedCell != null) {
      if (action == PlayerAction.move) {
        final center = Offset(
          selectedCell!.x * cellSize + cellSize / 2,
          selectedCell!.y * cellSize + cellSize / 2,
        );
        final radius = cellSize / 2 - 4;
        canvas.drawCircle(center, radius, selectedPaint);
      } else if (action == PlayerAction.shoot) {
        renderShootCross(canvas, selectedCell!, attackPaint);
      }
    }

    for (Vector2 shield in shields) {
      final center = Offset(
        shield.x * cellSize + cellSize / 2,
        shield.y * cellSize + cellSize / 2,
      );
      final radius = cellSize / 1.7;
      canvas.drawCircle(center, radius, shieldPaint);
    }
  }

  void renderShootCross(Canvas canvas, Vector2 cell, Paint paint) {
    final List<Vector2> offsets = [
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1),
    ];

    for (final o in offsets) {
      final c = Vector2(cell.x + o.x, cell.y + o.y);

      if (c.x < 0 || c.x >= sizeInCells || c.y < 0 || c.y >= sizeInCells) {
        continue;
      }

      canvas.drawRect(
        Rect.fromLTWH(c.x * cellSize, c.y * cellSize, cellSize, cellSize),
        paint,
      );
    }
  }
}
