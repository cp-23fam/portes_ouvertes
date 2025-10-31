import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';

class RoomRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('rooms');

  Stream<List<Room>> watchRoomList() {
    final snapshot = _collection.snapshots();

    return snapshot.map(
      (docs) => docs.docs.map((d) => Room.fromMap(d.data())).toList(),
    );
  }

  Future<void> createRoom() async {
    await _collection.add(
      Room(
        name: 'Test',
        hostId: '',
        users: [],
        status: RoomStatus.creating,
        maxPlayers: 20,
      ).toMap(),
    );
  }
}

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository();
});

final roomListStreamProvider = StreamProvider<List<Room>>((ref) {
  final roomRepo = ref.watch(roomRepositoryProvider);
  ref.read(roomRepositoryProvider).createRoom();
  return roomRepo.watchRoomList();
});
