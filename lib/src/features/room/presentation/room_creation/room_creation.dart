import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomCreation extends StatefulWidget {
  const RoomCreation({super.key});

  @override
  State<RoomCreation> createState() => _RoomCreationState();
}

class _RoomCreationState extends State<RoomCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: AppColors.secondeColor,
                      radius: 30.0,
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.iconColor,
                        size: 45.0,
                      ),
                    ),
                  ),
                ),
              ],
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
                        'Création de la Room'.hardcoded,
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
                        labelText: 'Nom de la Room'.hardcoded,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.p12),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // _searchQuery = value;
                        });
                      },
                    ),
                    gapH12,
                    TextField(
                      style: TextStyle(color: AppColors.titleColor),
                      decoration: InputDecoration(
                        labelText: 'Nombre de joueurs'.hardcoded,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Sizes.p12),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // _searchQuery = value;
                        });
                      },
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
