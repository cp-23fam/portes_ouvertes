import 'dart:convert';

typedef UserId = String;

class User {
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      username: map['username'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
  User({required this.uid, required this.username, required this.imageUrl});

  final UserId uid;
  final String username;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  User copyWith({UserId? uid, String? username, String? imageUrl}) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
