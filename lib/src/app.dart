import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Portes ouvertes',
      home: RoomListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
