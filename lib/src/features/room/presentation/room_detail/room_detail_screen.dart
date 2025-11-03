import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/no_user_card.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/user_card.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: AppColors.secondeColor,
                      radius: 30.0,
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.iconColor,
                        size: 45.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(Sizes.p8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.p20),
                ),
                color: AppColors.thirdColor,
                border: Border.all(width: 2.0, color: AppColors.iconColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p24),
                child: Text(
                  'Pro Player Only'.hardcoded,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: Sizes.p32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(Sizes.p8), child: UserCard()),
            const Padding(
              padding: EdgeInsets.all(Sizes.p8),
              child: NoUserCard(),
            ),
          ],
        ),
      ),
    );
  }
}
