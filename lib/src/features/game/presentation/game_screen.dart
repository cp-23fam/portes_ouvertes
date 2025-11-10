import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/features/game/data/game_repository.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';
import 'package:portes_ouvertes/src/features/game/my_game.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class GameScreen extends StatefulWidget {
  GameScreen({required this.gameId, super.key});
  // final playerId = 'p1';
  final playerId = FirebaseAuth.instance.currentUser!.uid;
  // final gameId = GameRepository().startGame(['p1', 'p2']);
  final String gameId;
  // MyGame myGame = ref.watch(gameStreamProvider());

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MyGame game = MyGame();
  String actualAction = '';

  void _onActionSelected(PlayerAction action) {
    if (action == PlayerAction.move) {
      game.highlightMoveZone(widget.playerId);
      game.players[0].action = PlayerAction.move;
    } else if (action == PlayerAction.melee) {
      game.highlightMeleeZone(widget.playerId);
      game.players[0].action = PlayerAction.melee;
    } else if (action == PlayerAction.shoot) {
      game.highlightShootZone(widget.playerId);
      game.players[0].action = PlayerAction.shoot;
    } else if (action == PlayerAction.block) {
      game.highlightBlockZone(widget.playerId);
      game.players[0].action = PlayerAction.block;
    } else {
      game.grid.clearHighlights();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Game
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 54 * 9,
                  width: 54 * 9,
                  child: Consumer(
                    builder: (context, ref, child) {
                      // final gameId = GameRepository().startGame(['p1', 'p2']);
                      // Game myGame = ref.watch(gameStreamProvider('oiafoa'));

                      final gameData = ref.watch(
                        gameStreamProvider(widget.gameId),
                      );
                      return gameData.when(
                        data: (gameClass) {
                          if (gameClass.status == GameStatus.starting) {
                            game.gameMerge(gameClass);
                          } else if (gameClass.status == GameStatus.showing) {
                            game.gameUpdatePlayers(gameClass);
                          }

                          // Autre fonction en cas de endRound --> Mettre à jour les players
                          return GameWidget(game: game);
                        },
                        error: (error, stackTrace) {
                          // print(stackTrace);
                          return Center(child: Text(error.toString()));
                        },
                        loading: () => const Placeholder(),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Action : $actualAction',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                // Interface
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    // padding: const EdgeInsets.only(bottom: 40.0),
                    padding: const EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 0,
                            child: _buildGameButton(
                              icon: Icons.arrow_forward,
                              color: Colors.green,
                              label: 'Move',
                              onPressed: () {
                                _onActionSelected(PlayerAction.move);
                                // setState(() {
                                //   actualAction = 'Move';
                                // });
                              },
                            ),
                          ),

                          Positioned(
                            left: 0,
                            child: _buildGameButton(
                              icon: Icons.flash_on,
                              color: Colors.red,
                              label: 'Atk',
                              onPressed: () =>
                                  _onActionSelected(PlayerAction.melee),
                            ),
                          ),

                          Positioned(
                            top: 0,
                            child: _buildGameButton(
                              icon: Icons.bolt,
                              color: Colors.orange,
                              label: 'Shoot',
                              onPressed: () =>
                                  _onActionSelected(PlayerAction.shoot),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            child: _buildGameButton(
                              icon: Icons.shield,
                              color: Colors.blue,
                              label: 'Defend',
                              onPressed: () =>
                                  _onActionSelected(PlayerAction.block),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const Expanded(child: SizedBox()),
            Consumer(
              builder: (context, ref, child) {
                return ImportantButton(
                  color: AppColors.goodColor,
                  text: 'Valider',
                  onPressed: () async {
                    final selected = game.grid.selectedCell;
                    final playerRef = game.getPlayerById(
                      widget.playerId,
                    ); // game.players[0];

                    if (selected != null) {
                      playerRef.target = selected;
                    }

                    PlayerModel player = PlayerModel(
                      uid: playerRef.id,
                      position: playerRef.position,
                      action: playerRef.action,
                      life: 3,
                      actionPos: playerRef.target,
                    );

                    await ref
                        .read(gameRepositoryProvider)
                        .playerSendAction(widget.gameId, player);

                    game.testUpdatePlayers(player);

                    // PlayerModel(uid: uid, position: position, action: action)

                    // game.playerValidated(widget.playerId);

                    // ------ Envoie du Player au Repository ------ \\

                    // ---------------------------------------------
                    // final selected = game.grid.selectedCell;
                    // if (selected != null) {
                    //   final player = game.players.firstWhere(
                    //     (p) => p.id == widget.playerId,
                    //   );
                    //   player.moveToCell(selected);
                    //   game.grid.clearHighlights();
                    // }
                    // ---------------------------------------------
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: label,
          onPressed: onPressed,
          backgroundColor: color.withAlpha(220),
          shape: const CircleBorder(),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
      ],
    );
  }
}
