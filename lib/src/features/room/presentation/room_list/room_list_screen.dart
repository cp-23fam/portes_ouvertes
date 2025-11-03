import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
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
      isConnected = user != null;
      if (user == null) {
        isConnected = false;
        // print('User is currently signed out!');
      } else {
        isConnected = true;
        // print('User is signed in!');
      }
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
                    'Lobby'.hardcoded,
                    style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      if (isConnected) {
                        context.goNamed(RouteNames.userPage.name);
                      } else {
                        context.goNamed(RouteNames.login.name);
                      }
                    },
                    child: MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          roundIsHover = true;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          roundIsHover = false;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: roundIsHover
                            ? AppColors.thirdColor
                            : AppColors.secondeColor,
                        radius: 30.0,
                        child: Icon(
                          isConnected ? Icons.person_outline : Icons.login,
                          color: AppColors.iconColor,
                          size: 45.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Recherche une room'.hardcoded,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  // _searchQuery = value;
                });
              },
            ),
            isConnected
                ? Consumer(
                    builder: (context, ref, child) {
                      final roomsStream = ref.watch(roomListStreamProvider);

                      return roomsStream.when(
                        data: (rooms) => Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return RoomCard(
                                room: rooms[index],
                                onClick: () {
                                  context.goNamed(
                                    RouteNames.details.name,
                                    pathParameters: {'id': rooms[index].id},
                                  );
                                },
                                isEnable: isConnected,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8.0),
                            itemCount: rooms.length,
                          ),
                        ),
                        error: (error, stackTrace) => Expanded(
                          child: Center(child: Text(error.toString())),
                        ),
                        loading: () => const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    },
                  )
                : const Expanded(child: Center(child: Text('...'))),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: !isConnected
                  ? Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.p20),
                        ),
                        color: AppColors.goodColor.withAlpha(100),
                      ),
                      child: Center(
                        child: Text(
                          'Créer une room',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: Sizes.p24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : ImportantButton(
                      color: AppColors.goodColor,
                      text: 'Créer une room',
                      onPressed: () =>
                          context.goNamed(RouteNames.creation.name),
                    ),
            ),
            // TextButton(
            //   onPressed: () => context.goNamed(RouteNames.creation.name),
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStateProperty.all<Color>(
            //       AppColors.goodColor,
            //     ),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: Sizes.p8,
            //       horizontal: Sizes.p20,
            //     ),
            //     child: Text(
            //       'Create a room'.hardcoded,
            //       style: TextStyle(
            //         color: AppColors.textColor,
            //         fontSize: Sizes.p24,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
