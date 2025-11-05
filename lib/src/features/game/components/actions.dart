import 'package:flame/game.dart';

enum PlayerActionType { move, attackClose, attackDistance, defend, none }

class PlayerAction {
  PlayerAction({required this.playerId, required this.type, this.target});

  final String playerId;
  final PlayerActionType type;
  final Vector2? target;
}
