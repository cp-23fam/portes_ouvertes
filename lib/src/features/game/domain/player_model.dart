import 'dart:convert';

import 'package:flame/components.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

enum PlayerAction { move, melee, shoot, block, none }

class PlayerModel {
  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    final position = map['position'] as Map<String, dynamic>;

    return PlayerModel(
      uid: map['uid'] as String,
      position: Vector2(position['x'], position['y']),
      action: PlayerAction.values.firstWhere((e) => e.name == map['action']),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);
  PlayerModel({
    required this.uid,
    required this.position,
    required this.action,
    this.imageUrl,
  });

  final UserId uid;
  final Vector2 position;
  final PlayerAction action;
  final String? imageUrl;

  PlayerModel copyWith({
    UserId? uid,
    Vector2? position,
    PlayerAction? action,
    String? imageUrl,
  }) {
    return PlayerModel(
      uid: uid ?? this.uid,
      position: position ?? this.position,
      action: action ?? this.action,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'position': {'x': position.x, 'y': position.y},
      'action': action.name,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());
}
