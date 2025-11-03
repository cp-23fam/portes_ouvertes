import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.room,
    required this.onClick,
    super.key,
    required this.isEnable,
  });

  final Room room;
  final VoidCallback onClick;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        color: AppColors.thirdColor,
        border: Border.all(width: 2.0, color: AppColors.iconColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(room.name), Text('Host : ${room.hostId}')],
                ),
                Text('${room.users.length} / ${room.maxPlayers} Players'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                  decoration: BoxDecoration(
                    color: AppColors.specialColor.withAlpha(100),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.p20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.p4,
                      horizontal: Sizes.p8,
                    ),
                    child: Center(child: Text('waiting ...')),
                  ),
                ),
                TextButton(
                  onPressed: isEnable ? onClick : () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      isEnable
                          ? AppColors.goodColor
                          : AppColors.goodColor.withAlpha(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.p8,
                      horizontal: Sizes.p20,
                    ),
                    child: Text(
                      'Join'.hardcoded,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: Sizes.p24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
