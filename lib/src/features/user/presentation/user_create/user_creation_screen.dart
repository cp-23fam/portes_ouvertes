import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserCreationScreen extends StatefulWidget {
  const UserCreationScreen({super.key});

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController userController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmController;

  @override
  void initState() {
    userController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: Text(
                          'Création d\'un utilisateur'.hardcoded,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: Sizes.p32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      gapH24,
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom d\'utilisateur';
                          }
                          return null;
                        },
                        controller: userController,
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
                      TextFormField(
                        validator: (value) =>
                            EmailValidator.validate(value ?? '')
                            ? null
                            : 'Veuillez entrer une adresse email valide',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }

                          return null;
                        },
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
                      gapH12,
                      TextFormField(
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Les mots de passe ne corespondent pas';
                          }

                          return null;
                        },
                        controller: confirmController,
                        style: TextStyle(color: AppColors.titleColor),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe'.hardcoded,
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
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: Consumer(
                builder: (context, ref, child) {
                  return ImportantButton(
                    color: AppColors.goodColor,
                    text: 'Créer'.hardcoded,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                        ref
                            .read(userRepositoryProvider)
                            .createUser(
                              userCredential.user!.uid,
                              userController.text,
                            );

                        if (context.mounted) {
                          context.goNamed(RouteNames.login.name);
                        }
                      }
                    },
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
