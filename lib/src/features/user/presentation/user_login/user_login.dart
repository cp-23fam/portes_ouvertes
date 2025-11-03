import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
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
                        'Création d\'un utilisateur'.hardcoded,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: Sizes.p32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    gapH24,
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
                    gapH12,
                    TextField(
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
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(Sizes.p32),
              child: ImportantButton(
                color: AppColors.goodColor,
                text: 'Créer'.hardcoded,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
