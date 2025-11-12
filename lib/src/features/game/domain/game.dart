import 'dart:convert';

import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

enum GameStatus { starting, choosing, showing, ended }

typedef GameId = String;

class Game {
  factory Game.fromMap(Map<String, dynamic> map) {
    final players = map['players'] as List<dynamic>;
    final blocked = map['blocked'] as List<dynamic>;

    return Game(
      id: map['id'],
      timestamp: map['timestamp'] as int,
      players: players.map((p) => PlayerModel.fromMap(p)).toList(),
      status: GameStatus.values.firstWhere((e) => e.name == map['status']),
      blocked: blocked.cast<String>(),
    );
  }
  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);
  Game({
    required this.id,
    required this.timestamp,
    required this.players,
    required this.status,
    required this.blocked,
  });

  final String id;
  final int timestamp;
  final List<PlayerModel> players;
  final GameStatus status;
  final List<UserId> blocked;

  Game copyWith({
    String? id,
    int? timestamp,
    List<PlayerModel>? players,
    GameStatus? status,
    List<UserId>? blocked,
  }) {
    return Game(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      players: players ?? this.players,
      status: status ?? this.status,
      blocked: blocked ?? this.blocked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'players': players.map((x) => x.toMap()).toList(),
      'status': status.name,
      'blocked': blocked,
    };
  }

  String toJson() => json.encode(toMap());
}
