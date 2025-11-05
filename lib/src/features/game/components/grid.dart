import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Grid extends PositionComponent with TapCallbacks {
  Grid({required this.sizeInCells, required this.cellSize}) {
    size = Vector2(sizeInCells * cellSize, sizeInCells * cellSize);
    anchor = Anchor.topLeft;
    position = Vector2.zero();
  }

  final int sizeInCells;
  final double cellSize;
  final List<Vector2> highlightedCells = [];
  Vector2? selectedCell;

  void highlightCells(List<Vector2> cells) {
    highlightedCells
      ..clear()
      ..addAll(cells);
    selectedCell = null;
  }

  void clearHighlights() {
    highlightedCells.clear();
    selectedCell = null;
  }

  @override
  bool onTapDown(TapDownEvent event) {
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

    // Draw lines
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

    // Highlights
    for (final cell in highlightedCells) {
      canvas.drawRect(
        Rect.fromLTWH(cell.x * cellSize, cell.y * cellSize, cellSize, cellSize),
        highlightPaint,
      );
    }

    // Selected cell
    if (selectedCell != null) {
      final center = Offset(
        selectedCell!.x * cellSize + cellSize / 2,
        selectedCell!.y * cellSize + cellSize / 2,
      );
      final radius = cellSize / 2 - 4;
      canvas.drawCircle(center, radius, selectedPaint);
    }
  }
}
