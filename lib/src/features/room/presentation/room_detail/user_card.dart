import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.userId, required this.isHost, super.key});

  final String userId;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
        color: AppColors.thirdColor,
        border: Border.all(
          width: 2.0,
          color: !isHost ? AppColors.iconColor : AppColors.hostColor,
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final userFuture = ref.watch(userStreamProvider(userId));

          return userFuture.when(
            data: (user) => Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondColor,
                    radius: 30.0,
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.iconColor,
                      size: 45.0,
                    ),
                  ),
                  gapW16,
                  Text(
                    user.username,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: Sizes.p24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  if (isHost)
                    Icon(Icons.star, color: AppColors.hostColor, size: 45.0),
                ],
              ),
            ),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            loading: () => Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondColor,
                    radius: 30.0,
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.iconColor,
                      size: 45.0,
                    ),
                  ),
                  gapW16,
                  Text(
                    '...'.hardcoded,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: Sizes.p24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  if (isHost)
                    Icon(Icons.star, color: AppColors.hostColor, size: 45.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
