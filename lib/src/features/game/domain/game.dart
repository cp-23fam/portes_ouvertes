import 'dart:convert';

import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';

enum GameStatus { starting, playing, ended }

typedef GameId = String;

class Game {
  Game({
    required this.id,
    required this.timestamp,
    required this.players,
    required this.status,
  });

  final String id;
  final int timestamp;
  final List<PlayerModel> players;
  final GameStatus status;

  Game copyWith({
    GameId? id,
    int? timestamp,
    List<PlayerModel>? players,
    GameStatus? status,
  }) {
    return Game(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      players: players ?? this.players,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'players': players.map((x) => x.toMap()).toList(),
      'status': status.name,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      timestamp: map['timestamp'] as int,
      players: List<PlayerModel>.from(
        (map['players'] as List<int>).map<PlayerModel>(
          (x) => PlayerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      status: GameStatus.values.firstWhere((e) => e.name == map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);
}
