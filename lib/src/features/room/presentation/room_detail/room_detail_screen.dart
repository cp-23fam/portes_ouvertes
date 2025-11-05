import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/user_card.dart';
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
              data: (room) => Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [BackArrow()],
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(Sizes.p8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Sizes.p20),
                      ),
                      color: AppColors.thirdColor,
                      border: Border.all(
                        width: 2.0,
                        color: AppColors.iconColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p24),
                      child: Text(
                        room.name,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: Sizes.p32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => index < room.users.length
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4.0),
                      itemCount: room.maxPlayers,
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) =>
                  Expanded(child: Center(child: Text(error.toString()))),
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
                      itemCount: 8,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
