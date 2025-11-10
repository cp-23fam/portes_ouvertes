import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/common_widgets/top_action_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_settings/profile_picture.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserSettingsScreen extends ConsumerStatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  ConsumerState<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  late final TextEditingController usernameComtroller;

  @override
  void initState() {
    usernameComtroller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameComtroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final userFuture = ref.watch(userStreamProvider(userId));
            // final authMethod =
            //     FirebaseAuth.instance.currentUser!.providerData[0].providerId;

            return userFuture.when(
              data: (user) {
                usernameComtroller.text = user.username;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TopActionButton(
                            icon: Icons.home,
                            onPressed: () =>
                                context.goNamed(RouteNames.home.name),
                          ),
                          TopActionButton(
                            icon: Icons.logout,
                            onPressed: () async {
                              context.goNamed(RouteNames.home.name);
                              await Future.delayed(Durations.short1);
                              FirebaseAuth.instance.signOut();
                            },
                          ),
                        ],
                      ),
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
                          TextFormField(
                            controller: usernameComtroller,
                            maxLength: 20,
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
                          // gapH12,
                          // TextFormField(
                          //   readOnly: true,
                          //   initialValue:
                          //       FirebaseAuth.instance.currentUser!.email!,
                          //   style: TextStyle(color: AppColors.titleColor),
                          //   decoration: InputDecoration(
                          //     labelText: 'Adresse mail'.hardcoded,
                          //     border: const OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(Sizes.p12),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // gapH12,
                          // if (FirebaseAuth
                          //         .instance
                          //         .currentUser!
                          //         .providerData[0]
                          //         .providerId ==
                          //     'password')
                          //   TextField(
                          //     style: TextStyle(color: AppColors.titleColor),
                          //     obscureText: true,
                          //     enableSuggestions: false,
                          //     autocorrect: false,
                          //     decoration: InputDecoration(
                          //       labelText: 'Mot de passe'.hardcoded,
                          //       border: const OutlineInputBorder(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(Sizes.p12),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
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
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(usernameComtroller.text);
                              await ref
                                  .read(userRepositoryProvider)
                                  .updateUser(
                                    user.copyWith(
                                      username: usernameComtroller.text,
                                    ),
                                  );

                              await FirebaseAuth.instance.currentUser!.reload();
                              setState(() {});
                            },
                          ),
                          // gapW8,
                          // ImportantButton(
                          //   color: AppColors.deleteColor,
                          //   text: 'Supprimer'.hardcoded,
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
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
