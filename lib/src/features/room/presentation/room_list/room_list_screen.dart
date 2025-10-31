import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_card.dart';
import 'package:portes_ouvertes/src/localization/string_hardcoded.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
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
                  padding: const EdgeInsets.all(Sizes.p20),
                  child: Text(
                    'Lobby'.hardcoded,
                    style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.secondeColor,
                    radius: 30.0,
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.iconColor,
                      size: 45.0,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              style: TextStyle(color: AppColors.titleColor),
              decoration: InputDecoration(
                labelText: 'Recherche une room'.hardcoded,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  // _searchQuery = value;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(Sizes.p8), child: RoomCard()),
          ],
        ),
      ),
    );
  }
}
