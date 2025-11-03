import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portes ouvertes',
      theme: blackTheme,
      home: const RoomListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
