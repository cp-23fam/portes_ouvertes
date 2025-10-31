typedef UserId = String;

enum RoomStatus { creating, waiting, playing }

class Room {
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
}
