import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerActionType { move, attackClose, attackDistance, defend, none }

class Player extends PositionComponent {
  Player({
    required this.id,
    required this.color,
    required Vector2 position,
    this.target,
    this.cellSize = 50,
  }) {
    this.position = Vector2(
      position.x * cellSize + cellSize / 2,
      position.y * cellSize + cellSize / 2,
    );

    size = Vector2.all(cellSize * 0.8);
    anchor = Anchor.center;
  }

  final String id;
  PlayerActionType action = PlayerActionType.none;
  Vector2? target;

  final Color color;
  bool isAlive = true;
  int lives = 3;
  final double cellSize;
  bool hasValidated = false;

  void moveToCell(Vector2 cell) {
    position = Vector2(
      cell.x * cellSize + cellSize / 2,
      cell.y * cellSize + cellSize / 2,
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}
