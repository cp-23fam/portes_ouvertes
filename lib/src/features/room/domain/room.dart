import 'dart:convert';

import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

typedef RoomId = String;

enum RoomStatus { creating, waiting, playing }

class Room {
  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Room.fromMap(Map<String, dynamic> map) {
    final users = map['users'] as List?;

    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      hostId: map['hostId'] as String,
      users: users == null ? [] : users.cast<String>(),
      status: RoomStatus.values.firstWhere((v) => v.name == map['status']),
      gameId: map['gameId'],
      maxPlayers: map['maxPlayers'] as int,
    );
  }

  Room({
    required this.id,
    required this.name,
    required this.hostId,
    required this.users,
    required this.status,
    required this.maxPlayers,
    this.gameId,
  });

  final RoomId id;
  final String name;
  final UserId hostId;
  final List<UserId> users;
  final RoomStatus status;
  final GameId? gameId;
  final int maxPlayers;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hostId': hostId,
      'users': users,
      'status': status.name,
      'gameId': gameId,
      'maxPlayers': maxPlayers,
    };
  }

  String toJson() => json.encode(toMap());

  Room copyWith({
    RoomId? id,
    String? name,
    UserId? hostId,
    List<UserId>? users,
    RoomStatus? status,
    GameId? gameId,
    int? maxPlayers,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      users: users ?? this.users,
      status: status ?? this.status,
      gameId: gameId ?? gameId,
      maxPlayers: maxPlayers ?? this.maxPlayers,
    );
  }
}
