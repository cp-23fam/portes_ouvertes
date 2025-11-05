import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/common_widgets/important_button.dart';
import 'package:portes_ouvertes/src/common_widgets/top_action_button.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/data/room_repository.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomCreationScreen extends StatefulWidget {
  const RoomCreationScreen({super.key});

  @override
  State<RoomCreationScreen> createState() => _RoomCreationScreenState();
}

class _RoomCreationScreenState extends State<RoomCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController numberController;

  @override
  void initState() {
    nameController = TextEditingController();
    numberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: Icons.arrow_back,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: Text(
                          'Création de la salle'.hardcoded,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: Sizes.p32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      gapH24,
                      TextFormField(
                        controller: nameController,
                        maxLength: 30,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a room name'.hardcoded;
                          }

                          return null;
                        },
                        style: TextStyle(color: AppColors.titleColor),
                        decoration: InputDecoration(
                          labelText: 'Nom de la Room'.hardcoded,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.p12),
                            ),
                          ),
                        ),
                      ),
                      gapH12,
                      TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number of players'.hardcoded;
                          }

                          final int number = int.parse(value);

                          if (number < 2 || number > 8) {
                            return 'Please enter a number between 2 and 8'
                                .hardcoded;
                          }

                          return null;
                        },
                        style: TextStyle(color: AppColors.titleColor),
                        decoration: InputDecoration(
                          labelText: 'Nombre de joueurs'.hardcoded,
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
                    text: 'Créer',
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        String id = await ref
                            .read(roomRepositoryProvider)
                            .createRoom(
                              nameController.text,
                              FirebaseAuth.instance.currentUser!.uid,
                              int.parse(numberController.text),
                            );
                        if (context.mounted) {
                          context.goNamed(
                            RouteNames.details.name,
                            pathParameters: {'id': id},
                          );
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
