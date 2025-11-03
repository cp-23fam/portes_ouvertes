import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';
import 'package:portes_ouvertes/src/features/user/domain/user.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_settings/profile_picture.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({required this.userId, super.key});

  final UserId userId;

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final userFuture = ref.watch(userFutureProvider(widget.userId));

            return userFuture.when(
              data: (user) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackArrow(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: MouseRegion(
                            onEnter: (event) {
                              setState(() {
                                isHover = true;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                isHover = false;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: isHover
                                  ? AppColors.thirdColor
                                  : AppColors.secondeColor,
                              radius: 30.0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: AppColors.iconColor,
                                  size: 40.0,
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  context.goNamed(RouteNames.login.name);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const ProfilePicture(),
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Text(
                      user.username,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: Sizes.p32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  gapH16,
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          style: TextStyle(color: AppColors.titleColor),
                          decoration: InputDecoration(
                            labelText: 'Nom d\'utilisateur'.hardcoded,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Sizes.p12),
                              ),
                            ),
                          ),
                        ),
                        gapH12,
                        TextField(
                          style: TextStyle(color: AppColors.titleColor),
                          decoration: InputDecoration(
                            labelText: 'Adresse mail'.hardcoded,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Sizes.p12),
                              ),
                            ),
                          ),
                        ),
                        gapH12,
                        TextField(
                          style: TextStyle(color: AppColors.titleColor),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe'.hardcoded,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Sizes.p12),
                              ),
                            ),
                          ),
                        ),
                        gapH20,
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImportantButton(
                          color: AppColors.goodColor,
                          text: 'Modifier'.hardcoded,
                          onPressed: () {},
                        ),
                        gapW8,
                        ImportantButton(
                          color: AppColors.deleteColor,
                          text: 'Supprimer'.hardcoded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     width: 200,
                  //     height: 50,
                  //     margin: const EdgeInsets.all(Sizes.p32),
                  //     decoration: BoxDecoration(
                  //       borderRadius: const BorderRadius.all(
                  //         Radius.circular(Sizes.p20),
                  //       ),
                  //       color: AppColors.goodColor,
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'Créer'.hardcoded,
                  //         style: TextStyle(
                  //           color: AppColors.textColor,
                  //           fontSize: Sizes.p24,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              error: (error, stackTrace) {
                print(stackTrace);
                return Center(
                  child: TextButton(
                    child: Text(error.toString()),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
