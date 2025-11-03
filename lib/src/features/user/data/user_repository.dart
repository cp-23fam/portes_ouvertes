import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('rooms');

  Future<User?> getUserFrom(String uid) async {
    final userMap = await _collection.doc(uid).get();
    if (userMap.data() != null) {
      return User.fromMap(userMap.data()!);
    }
    return null;
  }
}
