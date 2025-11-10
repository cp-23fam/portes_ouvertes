import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/game/data/game_repository.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/user_card.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({required this.roomId, super.key});

  final String? roomId;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final roomStream = ref.watch(roomStreamProvider(widget.roomId!));

            return roomStream.when(
              data: (room) {
                if (room.gameId != null) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    context.goNamed(
                      RouteNames.game.name,
                      pathParameters: {'id': room.gameId!},
                    );
                  });
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          // TopActionButton(
                          //   icon: Icons.arrow_back,
                          //   onPressed: () =>
                          //       context.goNamed(RouteNames.home.name),
                          // ),
                        ],
                      ),
                    ),
                    Text(
                      '${room.users.length} / ${room.maxPlayers} Joueurs'
                          .hardcoded,
                    ),
                    gapH12,
                    if (room.hostId == FirebaseAuth.instance.currentUser!.uid)
                      ImportantButton(
                        color: room.users.length > 1
                            ? AppColors.goodColor
                            : AppColors.goodColor.withAlpha(100),
                        text: 'Commencer'.hardcoded,
                        onPressed: room.users.length > 1
                            ? () async {
                                final gameId = await ref
                                    .read(gameRepositoryProvider)
                                    .startGame(room.users);

                                await ref
                                    .read(roomRepositoryProvider)
                                    .updateRoom(
                                      room.copyWith(
                                        gameId: gameId,
                                        status: RoomStatus.playing,
                                      ),
                                    );

                                if (context.mounted) {
                                  context.goNamed(
                                    RouteNames.game.name,
                                    pathParameters: {'id': gameId},
                                  );
                                }
                              }
                            : null,
                      ),
                    gapH8,
                    // Container(
                    //   width: double.infinity,
                    //   margin: const EdgeInsets.all(Sizes.p8),
                    //   decoration: BoxDecoration(
                    //     borderRadius: const BorderRadius.all(
                    //       Radius.circular(Sizes.p20),
                    //     ),
                    //     color: AppColors.thirdColor,
                    //     border: Border.all(
                    //       width: 2.0,
                    //       color: AppColors.iconColor,
                    //     ),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(Sizes.p24),
                    //     child: Text(
                    //       room.name,
                    //       style: TextStyle(
                    //         color: AppColors.textColor,
                    //         fontSize: Sizes.p32,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            index < room.users.length
                            ? Padding(
                                padding: const EdgeInsets.all(Sizes.p8),
                                child: UserCard(
                                  userId: room.users[index],
                                  isHost: index == 0 ? true : false,
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(Sizes.p8),
                                child: NoUserCard(),
                              ),
                        separatorBuilder: (context, index) => gapH4,
                        itemCount: room.maxPlayers,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p32),
                      child: ImportantButton(
                        color: AppColors.deleteColor,
                        text: 'Quitter'.hardcoded,
                        onPressed: () async {
                          context.goNamed(RouteNames.home.name);

                          if (room.hostId ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            print('Confirmation popup');
                            await ref
                                .read(roomRepositoryProvider)
                                .deleteRoom(room.id);
                          } else {
                            await ref
                                .read(roomRepositoryProvider)
                                .quitRoom(
                                  room.id,
                                  FirebaseAuth.instance.currentUser!.uid,
                                );
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                // context.goNamed(RouteNames.home.name);

                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Salle de jeu introuvable'.hardcoded),
                      gapH12,
                      ImportantButton(
                        color: AppColors.goodColor,
                        text: 'Retour'.hardcoded,
                        onPressed: () => context.goNamed(RouteNames.home.name),
                      ),
                    ],
                  ),
                );
              },
              loading: () => Expanded(
                child:
                    // Center(child: CircularProgressIndicator()),
                    ListView.separated(
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.all(Sizes.p8),
                        child: NoUserCard(),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4.0),
                      itemCount: 1,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
