import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key});

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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pro Players Only'),
                    Text('Host : MasterMind'),
                  ],
                ),
                Text('6 / 8 Players'),
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
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      AppColors.goodColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.p8,
                      horizontal: Sizes.p20,
                    ),
                    child: Text(
                      'Join',
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
