import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('users');

  Future<User?> getUserFrom(String uid) async {
    final userMap = await _collection.doc(uid).get();
    if (userMap.data() != null) {
      return User.fromMap(userMap.data()!);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _collection.doc(user.uid).set(user.toMap());
  }

  Future<void> deleteUser(UserId uid) async {
    await _collection.doc(uid).delete();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
