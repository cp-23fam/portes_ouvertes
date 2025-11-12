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
  MyGame? flameGame;
  String actualAction = '';

  void _onActionSelected(PlayerAction action) {
    if (flameGame!.status != GameStatus.choosing) {
      return;
    }

    if (action == PlayerAction.move) {
      flameGame!.getPlayerById(widget.playerId).action = PlayerAction.move;
      flameGame!.highlightMoveZone(widget.playerId);
    } else if (action == PlayerAction.melee) {
      flameGame!.highlightMeleeZone(widget.playerId);
      flameGame!.getPlayerById(widget.playerId).action = PlayerAction.melee;
    } else if (action == PlayerAction.shoot) {
      flameGame!.highlightShootZone(widget.playerId);
      flameGame!.getPlayerById(widget.playerId).action = PlayerAction.shoot;
    } else if (action == PlayerAction.block) {
      flameGame!.highlightBlockZone(widget.playerId);
      flameGame!.getPlayerById(widget.playerId).action = PlayerAction.block;
    } else {
      flameGame!.grid.clearHighlights();
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
        child: Consumer(
          builder: (context, ref, child) {
            final gameData = ref.watch(gameStreamProvider(widget.gameId));

            return gameData.when(
              data: (game) {
                late final PlayerModel? player;

                try {
                  player = game.players.firstWhere(
                    (p) => p.uid == widget.playerId,
                  );
                } catch (e) {
                  player = null;
                }

                bool canValidate = player?.action == PlayerAction.none;

                flameGame ??= MyGame(ref: ref);

                flameGame!.timestamp = game.timestamp;
                flameGame!.status = game.status;

                if (!flameGame!.isInit) {
                  flameGame!.gameId = widget.gameId;
                  flameGame!.gameMerge(game);
                  flameGame!.isInit = true;
                }

                if (game.status == GameStatus.starting) {
                  ref.read(gameRepositoryProvider).startChoosing(widget.gameId);
                }

                if (game.status == GameStatus.showing) {
                  flameGame!.gameUpdatePlayers(game);
                  canValidate = false;
                }

                if (game.status == GameStatus.ended) {
                  ref.read(roomRepositoryProvider).deleteRoom(widget.roomId);

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    context.goNamed(RouteNames.home.name);
                  });
                }

                return Column(
                  children: [
                    // Game
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 54 * 9,
                          width: 54 * 9,
                          child: GameWidget(game: flameGame!),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    lifeWidget(player?.life ?? 0),

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
                                      isValidated: canValidate,
                                      onPressed: () =>
                                          _onActionSelected(PlayerAction.move),
                                    ),
                                  ),

                                  Positioned(
                                    left: 0,
                                    child: _buildGameButton(
                                      icon: Icons.flash_on,
                                      color: Colors.red,
                                      label: 'Atk',
                                      isValidated: canValidate,
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
                                      isValidated: canValidate,
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
                                      isValidated:
                                          canValidate &&
                                          !game.blocked.contains(
                                            widget.playerId,
                                          ),
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
                    player != null
                        ? ImportantButton(
                            color: canValidate
                                ? AppColors.goodColor
                                : AppColors.thirdColor,
                            text: 'Valider',
                            onPressed: canValidate
                                ? () async {
                                    final selected =
                                        flameGame!.grid.selectedCell;
                                    final playerRef = flameGame!.getPlayerById(
                                      widget.playerId,
                                    );

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
                                        .playerSendAction(
                                          widget.gameId,
                                          player,
                                        );
                                  }
                                : null,
                          )
                        : ImportantButton(
                            color: AppColors.deleteColor,
                            text: 'Quitter',
                            onPressed: () =>
                                context.goNamed(RouteNames.home.name),
                          ),
                  ],
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const Placeholder(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback? onPressed,
    required bool isValidated,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: label,
          onPressed: isValidated ? onPressed : null,
          backgroundColor: isValidated
              ? color.withAlpha(220)
              : color.withAlpha(100),
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
