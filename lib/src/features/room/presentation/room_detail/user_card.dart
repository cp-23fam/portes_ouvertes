import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
        color: AppColors.thirdColor,
        border: Border.all(
          width: 2.0,
          color: AppColors.iconColor,
          // color: AppColors.hostColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.secondeColor,
              radius: 30.0,
              child: Icon(
                Icons.person_outline,
                color: AppColors.iconColor,
                size: 45.0,
              ),
            ),
            gapW16,
            Text(
              'MasterMind'.hardcoded,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: Sizes.p24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(child: SizedBox()),
            // Icon(
            //   Icons.hourglass_bottom,
            //   color: AppColors.hostColor,
            //   size: 45.0,
            // ),
          ],
        ),
      ),
    );
  }
}
