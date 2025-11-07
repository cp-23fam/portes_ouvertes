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
        timestamp: DateTime.now().millisecondsSinceEpoch + 20 * 1000,
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

  Stream<Game> watchGame(GameId id) {
    final docData = _collection.doc(id).snapshots();

    return docData.map((d) => Game.fromMap(d.data()!));
  }

  Future<void> playerSendAction(
    GameId id,
    PlayerModel player, [
    int milliseconds = 10 * 1000,
  ]) async {
    final gameData = await _collection.doc(id).get();
    final game = Game.fromMap(gameData.data()!);

    final playerIndex = game.players.indexWhere((p) => p.uid == player.uid);
    game.players[playerIndex] = player;

    await _collection
        .doc(id)
        .set(game.copyWith(timestamp: game.timestamp + milliseconds).toMap());
  }
}

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

final gameStreamProvider = StreamProvider.family<Game, GameId>((ref, id) {
  final gameRepo = ref.watch(gameRepositoryProvider);
  return gameRepo.watchGame(id);
});
