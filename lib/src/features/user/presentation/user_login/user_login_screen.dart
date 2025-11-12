import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/common_widgets/top_action_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';
import 'package:sign_button/sign_button.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  String? emailErrorText;
  String? passwordErrorText;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null && context.mounted) {
        context.goNamed(RouteNames.user.name);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopActionButton(
                    icon: Icons.home,
                    onPressed: () => context.goNamed(RouteNames.home.name),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(Sizes.p8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.p20),
                ),
                color: AppColors.fourthColor,
                border: Border.all(width: 2.0, color: AppColors.iconColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Text(
                        'Connexion'.hardcoded,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: Sizes.p32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    gapH24,
                    TextFormField(
                      forceErrorText: emailErrorText,
                      controller: emailController,
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
                    TextFormField(
                      forceErrorText: passwordErrorText,
                      controller: passwordController,
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
                    Center(child: Text('ou'.hardcoded)),
                    gapH20,
                    Center(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return SignInButton(
                            btnText: 'Connexion Google'.hardcoded,
                            buttonType: ButtonType.google,
                            buttonSize: ButtonSize.medium,
                            onPressed: () async {
                              late final UserCredential userCredential;

                              try {
                                if (kIsWeb) {
                                  userCredential = await FirebaseAuth.instance
                                      .signInWithPopup(GoogleAuthProvider());
                                } else {
                                  userCredential = await FirebaseAuth.instance
                                      .signInWithProvider(GoogleAuthProvider());
                                }

                                ref
                                    .read(userRepositoryProvider)
                                    .createUser(
                                      userCredential.user!.uid,
                                      userCredential.user!.displayName ??
                                          userCredential.user!.email!.split(
                                            '@',
                                          )[0],
                                      imageUrl: userCredential.user!.photoURL,
                                    );

                                if (context.mounted) {
                                  context.goNamed(RouteNames.home.name);
                                }
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'invalid-email':
                                    setState(() {
                                      emailErrorText =
                                          'Mail invalide'.hardcoded;
                                    });
                                  case 'user-not-found':
                                    setState(() {
                                      emailErrorText =
                                          'Mail non trouvé'.hardcoded;
                                    });
                                  case 'wrong-password':
                                    setState(() {
                                      passwordErrorText =
                                          'Mauvais mot de passe'.hardcoded;
                                    });

                                  default:
                                    rethrow;
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    gapH8,
                    Center(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return SignInButton(
                            btnText: 'Connexion GitHub'.hardcoded,
                            buttonType: ButtonType.github,
                            buttonSize: ButtonSize.medium,
                            btnColor: AppColors.thirdColor,
                            btnTextColor: AppColors.textColor,
                            onPressed: () async {
                              late final UserCredential userCredential;

                              if (kIsWeb) {
                                userCredential = await FirebaseAuth.instance
                                    .signInWithPopup(GoogleAuthProvider());
                              } else {
                                userCredential = await FirebaseAuth.instance
                                    .signInWithProvider(GoogleAuthProvider());
                              }

                              ref
                                  .read(userRepositoryProvider)
                                  .createUser(
                                    userCredential.user!.uid,
                                    userCredential.user!.displayName ??
                                        userCredential.user!.email!.split(
                                          '@',
                                        )[0],
                                    imageUrl: userCredential.user!.photoURL,
                                  );

                              if (context.mounted) {
                                context.goNamed(RouteNames.home.name);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    gapH20,
                    Center(
                      child: SignInButton(
                        buttonType: ButtonType.mail,
                        btnText: 'Créer un compte'.hardcoded,
                        onPressed: () {
                          context.goNamed(RouteNames.signup.name);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: ImportantButton(
                color: AppColors.goodColor,
                text: 'Connexion'.hardcoded,
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.value.text,
                      password: passwordController.value.text,
                    );

                    if (context.mounted) {
                      context.goNamed(RouteNames.home.name);
                    }
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'invalid-email':
                        setState(() {
                          emailErrorText = 'Mail invalide'.hardcoded;
                        });
                      case 'user-not-found':
                        setState(() {
                          emailErrorText = 'Mail non trouvé'.hardcoded;
                        });
                      case 'wrong-password':
                        setState(() {
                          passwordErrorText = 'Mauvais mot de passe'.hardcoded;
                        });

                      default:
                        rethrow;
                    }
                  } catch (e) {
                    rethrow;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SignInButton(
//   buttonType: ButtonType.google,
//   onPressed: () {
//    print('click');
//   })
