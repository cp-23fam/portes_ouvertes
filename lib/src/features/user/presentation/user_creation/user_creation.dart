import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/common_widgets/back_arrow.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';
import 'package:sign_button/sign_button.dart';

class UserCreation extends StatefulWidget {
  const UserCreation({super.key});

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {
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
                        'Création d\'un Utilisateur'.hardcoded,
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
                    const Center(child: Text('ou')),
                    gapH20,
                    Center(
                      child: SignInButton(
                        buttonType: ButtonType.google,
                        buttonSize: ButtonSize.medium,
                        onPressed: () {},
                      ),
                    ),
                    gapH8,
                    Center(
                      child: SignInButton(
                        buttonType: ButtonType.github,
                        buttonSize: ButtonSize.medium,
                        btnColor: AppColors.thirdColor,
                        btnTextColor: AppColors.textColor,
                        onPressed: () {},
                      ),
                    ),
                    gapH20,
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.all(Sizes.p32),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.p20),
                  ),
                  color: AppColors.goodColor,
                ),
                child: Center(
                  child: Text(
                    'Créer'.hardcoded,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: Sizes.p24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
