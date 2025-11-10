import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';

class Player extends PositionComponent {
  Player({
    required this.id,
    required this.color,
    required this.lives,
    required Vector2 position,
    this.target,
    // this.cellSize = 54,
  }) {
    this.position = Vector2(
      position.x * cellSize + cellSize / 2,
      position.y * cellSize + cellSize / 2,
    );

    size = Vector2.all(cellSize * 0.8);
    anchor = Anchor.center;
  }

  final String id;
  PlayerAction action = PlayerAction.none;
  Vector2? target;

  final Color color;
  bool isAlive = true;
  int lives;
  final double cellSize = 54;

  void moveToCell(Vector2 cell) {
    position = Vector2(
      cell.x * cellSize + cellSize / 2,
      cell.y * cellSize + cellSize / 2,
    );
  }

  void moveToPixel(Vector2 cell) {
    position = Vector2(cell.x, cell.y);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}
