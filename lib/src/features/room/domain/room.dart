import 'dart:convert';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

enum RoomStatus { creating, waiting, playing }

class Room {
  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Room.fromMap(Map<String, dynamic> map) {
    final users = map['users'] as List?;

    return Room(
      name: map['name'] as String,
      hostId: map['hostId'] as String,
      users: users == null ? [] : users.cast<String>(),
      status: RoomStatus.values.firstWhere((v) => v.name == map['status']),
      maxPlayers: map['maxPlayers'] as int,
    );
  }

  Room({
    required this.name,
    required this.hostId,
    required this.users,
    required this.status,
    required this.maxPlayers,
  });

  final String name;
  final UserId hostId;
  final List<UserId> users;
  final RoomStatus status;
  final int maxPlayers;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'hostId': hostId,
      'users': users,
      'status': status.name,
      'maxPlayers': maxPlayers,
    };
  }

  String toJson() => json.encode(toMap());
}
