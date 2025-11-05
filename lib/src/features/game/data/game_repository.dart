import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class GameRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('games');

  Future<String> startGame(List<UserId> players) async {
    final doc = _collection.doc();

    await doc.set(
      Game(
        id: doc.id,
        timestamp: DateTime.now().millisecondsSinceEpoch + 6 * 1000,
        players: players
            .map(
              (id) => PlayerModel(
                uid: id,
                position: Vector2(0, 0),
                action: PlayerAction.none,
              ),
            )
            .toList(),
        status: GameStatus.starting,
      ).toMap(),
    );

    return doc.id;
  }

  Future<Game> fetchGame(GameId id) async {
    final docData = await _collection.doc(id).get();

    return Game.fromMap(docData.data()!);
  }
}

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});
