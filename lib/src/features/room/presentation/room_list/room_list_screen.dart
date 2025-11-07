import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/common_widgets/top_action_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_card.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late bool isConnected = false;
  bool roundIsHover = false;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        isConnected = user != null;
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p20),
                  child: Text(
                    'Salles'.hardcoded,
                    style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TopActionButton(
                    icon: isConnected ? Icons.person : Icons.login,
                    onPressed: () => context.goNamed(RouteNames.user.name),
                  ),
                ),
              ],
            ),
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Rechercher une salle'.hardcoded,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  // _searchQuery = value;
                });
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final roomsStream = ref.watch(roomListStreamProvider);

                return roomsStream.when(
                  data: (rooms) => Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final room = rooms[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.p4,
                            horizontal: Sizes.p12,
                          ),
                          child: RoomCard(
                            room: room,
                            onClick: isConnected
                                ? room.maxPlayers == room.users.length
                                      ? null
                                      : room.status == RoomStatus.playing
                                      ? null
                                      : () async {
                                          context.goNamed(
                                            RouteNames.details.name,
                                            pathParameters: {
                                              'id': rooms[index].id,
                                            },
                                          );

                                          await ref
                                              .read(roomRepositoryProvider)
                                              .joinRoom(
                                                room.id,
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              );
                                        }
                                : null,
                            isEnable: isConnected,
                          ),
                        );
                      },
                      itemCount: rooms.length,
                    ),
                  ),
                  error: (error, stackTrace) =>
                      Expanded(child: Center(child: Text(error.toString()))),
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: !isConnected
                  ? ImportantButton(
                      color: AppColors.goodColor.withAlpha(100),
                      text: 'Créer une salle'.hardcoded,
                      onPressed: null,
                    )
                  : ImportantButton(
                      color: AppColors.goodColor,
                      text: 'Créer une salle'.hardcoded,
                      onPressed: () =>
                          context.goNamed(RouteNames.creation.name),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
