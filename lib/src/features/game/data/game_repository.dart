import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';

class GameRepository {
  final _db = FirebaseFirestore.instance;
  late final _collection = _db.collection('games');

  Future<String> startGame(List<UserId> players, [String id = '']) async {
    late final DocumentReference<Map<String, dynamic>> doc;
    if (id.isEmpty) {
      doc = _collection.doc();
    } else {
      doc = _collection.doc(id);
    }

    List<List<Vector2>> poses = [
      [Vector2(4, 1), Vector2(4, 7)],
      [Vector2(4, 2), Vector2(1, 7), Vector2(7, 7)],
      [Vector2(4, 1), Vector2(4, 7), Vector2(1, 4), Vector2(7, 4)],
      [
        Vector2(1, 1),
        Vector2(1, 7),
        Vector2(4, 4),
        Vector2(7, 1),
        Vector2(7, 7),
      ],
      [
        Vector2(1, 1),
        Vector2(1, 7),
        Vector2(1, 4),
        Vector2(7, 1),
        Vector2(7, 4),
        Vector2(7, 7),
      ],
      [
        Vector2(1, 1),
        Vector2(1, 7),
        Vector2(1, 4),
        Vector2(4, 4),
        Vector2(7, 1),
        Vector2(7, 4),
        Vector2(7, 7),
      ],
      [
        Vector2(1, 1),
        Vector2(1, 4),
        Vector2(1, 7),
        Vector2(4, 1),
        Vector2(4, 7),
        Vector2(7, 1),
        Vector2(7, 4),
        Vector2(7, 7),
      ],
    ];

    List<PlayerModel> gamePlayers = [];

    for (int i = 0; i < players.length; i++) {
      gamePlayers.add(
        PlayerModel(
          uid: players[i],
          position: poses[players.length - 2][i],
          action: PlayerAction.none,
          life: 3,
          actionPos: null,
        ),
      );
    }

    await doc.set(
      Game(
        id: doc.id,
        timestamp: DateTime.now().millisecondsSinceEpoch + 5 * 1000,
        players: gamePlayers,
        status: GameStatus.starting,
      ).toMap(),
    );

    return doc.id;
  }

  Stream<Game> watchGame(GameId id) {
    final docData = _collection.doc(id).snapshots();

    return docData.map((d) => Game.fromMap(d.data()!));
  }

  Future<void> startChoosing(GameId id) async {
    final gameData = await _collection.doc(id).get();
    final game = Game.fromMap(gameData.data()!);

    if (game.status == GameStatus.starting) {
      await _collection
          .doc(id)
          .set(
            game
                .copyWith(
                  timestamp: game.timestamp + 15 * 1000,
                  status: GameStatus.choosing,
                )
                .toMap(),
          );
    }
  }

  Future<void> playerSendAction(
    GameId id,
    PlayerModel player, [
    int milliseconds = 10 * 1000,
  ]) async {
    final gameData = await _collection.doc(id).get();
    final game = Game.fromMap(gameData.data()!);

    final players = game.players;

    final playerIndex = players.indexWhere((p) => p.uid == player.uid);
    players[playerIndex] = player;

    if (players.indexWhere((p) => p.action == PlayerAction.none) == -1) {
      await _collection
          .doc(id)
          .set(
            game
                .copyWith(
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  players: players,
                )
                .toMap(),
          );
    } else {
      await _collection
          .doc(id)
          .set(
            game
                .copyWith(
                  timestamp:
                      DateTime.now().millisecondsSinceEpoch + milliseconds,
                  players: players,
                )
                .toMap(),
          );
    }
  }

  Future<List<Vector2>> playActions(GameId id) async {
    final gameData = await _collection.doc(id).get();
    final game = Game.fromMap(gameData.data()!);

    List<Vector2> dangerPos = [];

    for (PlayerModel p in game.players) {
      switch (p.action) {
        case PlayerAction.melee:
          final Vector2 basePos = p.position;

          for (int i = 0; i < 9; i++) {
            dangerPos.add(
              Vector2(basePos.x + (i % 3) - 1, basePos.y + (i / 3).floor() - 1),
            );
          }
        case PlayerAction.shoot:
          final Vector2 basePos = p.actionPos!;

          for (int i = 0; i < 3; i++) {
            dangerPos.add(Vector2(basePos.x - 1 + i, basePos.y));
          }
          break;
        default:
          continue;
      }
    }

    if (game.status == GameStatus.choosing) {
      final List<PlayerModel> players = [];

      for (PlayerModel p in game.players) {
        if (p.action == PlayerAction.move) {
          try {
            dangerPos.firstWhere(
              (pos) => pos.x == p.actionPos!.x && pos.y == p.actionPos!.y,
            );

            players.add(p.copyWith(life: p.life - 1));
          } catch (e) {
            players.add(p);
          }
        } else {
          try {
            dangerPos.firstWhere(
              (pos) => pos.x == p.position.x && pos.y == p.position.y,
            );

            players.add(p.copyWith(life: p.life - 1));
          } catch (e) {
            players.add(p);
          }
        }
      }

      print(players);

      await _collection
          .doc(id)
          .set(
            game
                .copyWith(
                  status: GameStatus.showing,
                  players: players,
                  timestamp: game.timestamp + 10 * 1000,
                )
                .toMap(),
          );
    }

    return dangerPos;
  }

  Future<void> nextRound(GameId id) async {
    final gameData = await _collection.doc(id).get();
    final game = Game.fromMap(gameData.data()!);

    if (game.status == GameStatus.showing) {
      await _collection
          .doc(id)
          .set(
            game
                .copyWith(
                  status: GameStatus.choosing,
                  timestamp: DateTime.now().millisecondsSinceEpoch + 15 * 1000,
                )
                .toMap(),
          );
    }
  }
}

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

final gameStreamProvider = StreamProvider.autoDispose.family<Game, GameId>((
  ref,
  id,
) {
  final gameRepo = ref.watch(gameRepositoryProvider);
  return gameRepo.watchGame(id);
});
