import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    TextField(
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
                    TextField(
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
                    const Center(child: Text('ou')),
                    gapH20,
                    Center(
                      child: SignInButton(
                        btnText: 'Connexion Google'.hardcoded,
                        buttonType: ButtonType.google,
                        buttonSize: ButtonSize.medium,
                        onPressed: () {
                          if (kIsWeb) {
                            FirebaseAuth.instance.signInWithPopup(
                              GoogleAuthProvider(),
                            );
                          } else {
                            FirebaseAuth.instance.signInWithProvider(
                              GoogleAuthProvider(),
                            );
                          }
                        },
                      ),
                    ),
                    gapH8,
                    Center(
                      child: SignInButton(
                        btnText: 'Connexion GitHub'.hardcoded,
                        buttonType: ButtonType.github,
                        buttonSize: ButtonSize.medium,
                        btnColor: AppColors.thirdColor,
                        btnTextColor: AppColors.textColor,
                        onPressed: () {
                          if (kIsWeb) {
                            FirebaseAuth.instance.signInWithPopup(
                              GithubAuthProvider(),
                            );
                          } else {
                            FirebaseAuth.instance.signInWithProvider(
                              GithubAuthProvider(),
                            );
                          }
                        },
                      ),
                    ),
                    gapH20,
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: ImportantButton(
                color: AppColors.goodColor,
                text: 'Connexion',
                onPressed: () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.value.text,
                    password: passwordController.value.text,
                  );
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
