import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('users');

  Future<User> getUserFrom(String uid) async {
    final userMap = await _collection.doc(uid).get();

    return User.fromMap(userMap.data()!);
  }

  Future<void> updateUser(User user) async {
    await _collection.doc(user.uid).set(user.toMap());
  }

  Future<void> deleteUser(UserId uid) async {
    await _collection.doc(uid).delete();
  }

  Future<void> createUser(
    String uid,
    String username, {
    String? imageUrl,
  }) async {
    await _collection
        .doc(uid)
        .set(User(uid: uid, username: username, imageUrl: imageUrl).toMap());
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userFutureProvider = FutureProvider.family<User, String>((ref, uid) {
  final userRepo = ref.watch(userRepositoryProvider);

  return userRepo.getUserFrom(uid);
});
