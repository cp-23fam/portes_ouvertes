import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/domain/room.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomStatusWidget extends StatelessWidget {
  const RoomStatusWidget({required this.status, super.key});

  final RoomStatus status;

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String text;

    switch (status) {
      case RoomStatus.waiting:
        color = AppColors.specialColor.withAlpha(100);
        text = 'En attente'.hardcoded;
        break;
      case RoomStatus.playing:
        color = AppColors.deleteColor.withAlpha(100);
        text = 'En jeu'.hardcoded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p4,
          horizontal: Sizes.p8,
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
