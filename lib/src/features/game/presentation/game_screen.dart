import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/game/data/game_repository.dart';
import 'package:portes_ouvertes/src/features/game/domain/game.dart';
import 'package:portes_ouvertes/src/features/game/domain/player_model.dart';
import 'package:portes_ouvertes/src/features/game/my_game.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class GameScreen extends StatefulWidget {
  GameScreen({required this.roomId, required this.gameId, super.key});

  final playerId = FirebaseAuth.instance.currentUser!.uid;
  final String roomId;
  final String gameId;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MyGame? game;
  String actualAction = '';

  void _onActionSelected(PlayerAction action) {
    if (game!.status != GameStatus.choosing) {
      return;
    }

    if (action == PlayerAction.move) {
      game!.getPlayerById(widget.playerId).action = PlayerAction.move;
      game!.highlightMoveZone(widget.playerId);
    } else if (action == PlayerAction.melee) {
      game!.highlightMeleeZone(widget.playerId);
      game!.getPlayerById(widget.playerId).action = PlayerAction.melee;
    } else if (action == PlayerAction.shoot) {
      game!.highlightShootZone(widget.playerId);
      game!.getPlayerById(widget.playerId).action = PlayerAction.shoot;
    } else if (action == PlayerAction.block) {
      game!.highlightBlockZone(widget.playerId);
      game!.getPlayerById(widget.playerId).action = PlayerAction.block;
    } else {
      game!.grid.clearHighlights();
    }
  }

  Widget lifeWidget(int life) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Sizes.p4,
      children: [
        if (life == 0)
          const Icon(Icons.heart_broken)
        else
          for (int i = 0; i < life; i++)
            Icon(Icons.favorite, color: BasicPalette.red.color),
      ],
    );
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
                      final gameData = ref.watch(
                        gameStreamProvider(widget.gameId),
                      );
                      return gameData.when(
                        data: (gameClass) {
                          game ??= MyGame(ref: ref);

                          game!.timestamp = gameClass.timestamp;
                          game!.status = gameClass.status;

                          if (!game!.isInit) {
                            game!.gameId = widget.gameId;
                            game!.gameMerge(gameClass);
                            game!.isInit = true;
                          }

                          if (gameClass.status == GameStatus.starting) {
                            ref
                                .read(gameRepositoryProvider)
                                .startChoosing(widget.gameId);
                          }

                          if (gameClass.status == GameStatus.showing) {
                            game!.gameUpdatePlayers(gameClass);
                          }

                          if (gameClass.status == GameStatus.ended) {
                            ref
                                .read(roomRepositoryProvider)
                                .deleteRoom(widget.roomId);

                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              context.goNamed(RouteNames.home.name);
                            });
                          }

                          return GameWidget(game: game!);
                        },
                        error: (error, stackTrace) {
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
            Consumer(
              builder: (context, ref, child) {
                final gameStatus = ref.watch(gameStreamProvider(widget.gameId));

                return gameStatus.when(
                  data: (game) {
                    try {
                      final player = game.players.firstWhere(
                        (p) => p.uid == FirebaseAuth.instance.currentUser!.uid,
                      );

                      return lifeWidget(player.life);
                    } catch (e) {
                      return lifeWidget(0);
                    }
                  },
                  loading: () => lifeWidget(3),
                  error: (error, stackTrace) => lifeWidget(3),
                );
              },
            ),
            Stack(
              children: [
                // Interface
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
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
            Consumer(
              builder: (context, ref, child) {
                return ImportantButton(
                  color: AppColors.goodColor,
                  text: 'Valider',
                  onPressed: () async {
                    final selected = game!.grid.selectedCell;
                    final playerRef = game!.getPlayerById(widget.playerId);

                    if (selected != null) {
                      playerRef.target = selected;
                    }

                    PlayerModel player = PlayerModel(
                      uid: playerRef.id,
                      position: playerRef.position,
                      action: playerRef.action,
                      life: playerRef.lives,
                      actionPos: playerRef.target,
                    );

                    await ref
                        .read(gameRepositoryProvider)
                        .playerSendAction(widget.gameId, player);
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
