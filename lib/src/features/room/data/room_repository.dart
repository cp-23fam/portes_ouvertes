import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class RoomRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('rooms');

  Stream<List<Room>> watchRoomList() {
    final snapshot = _collection.snapshots();

    return snapshot.map(
      (docs) => docs.docs.map((d) => Room.fromMap(d.data())).toList(),
    );
  }

  Stream<Room> watchRoom(RoomId id) {
    final snapshot = _collection.doc(id).snapshots();

    return snapshot.map((r) => Room.fromMap(r.data()!));
  }

  Future<String> createRoom(String name, UserId hostId, int maxPlayers) async {
    final doc = _collection.doc();

    final room = Room(
      id: doc.id,
      name: name,
      hostId: hostId,
      users: [hostId],
      status: RoomStatus.waiting,
      maxPlayers: maxPlayers,
    );

    await doc.set(room.toMap());

    return doc.id;
  }

  Future<void> updateRoom(Room room) async {
    await _collection.doc(room.id).set(room.toMap());
  }

  Future<void> deleteRoom(RoomId id) async {
    await _collection.doc(id).delete();
  }

  Future<void> joinRoom(RoomId id, UserId uid) async {
    final roomData = await _collection.doc(id).get();
    final Room room = Room.fromMap(roomData.data()!);
    room.users.add(uid);

    if (room.users.length <= room.maxPlayers) {
      await updateRoom(room);
    }
  }

  Future<void> quitRoom(RoomId id, UserId uid) async {
    final roomData = await _collection.doc(id).get();
    final Room room = Room.fromMap(roomData.data()!);
    room.users.remove(uid);

    await updateRoom(room);
  }
}

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository();
});

final roomListStreamProvider = StreamProvider.autoDispose<List<Room>>((ref) {
  final roomRepo = ref.watch(roomRepositoryProvider);
  return roomRepo.watchRoomList();
});

final roomStreamProvider = StreamProvider.autoDispose.family<Room, String>((
  ref,
  roomId,
) {
  final roomRepo = ref.watch(roomRepositoryProvider);

  return roomRepo.watchRoom(roomId);
});

List<Room> filterRooms(String query, List<Room> rooms) {
  if (query.isEmpty) {
    return rooms;
  }

  rooms.sort((a, b) => a.name.compareTo(b.name));

  return rooms
      .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
