import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/presentation/game_screen.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   title: 'Portes ouvertes',
    //   theme: blackTheme,
    //   routerConfig: router,
    //   debugShowCheckedModeBanner: false,
    // );
    return MaterialApp(
      title: 'Portes ouvertes',
      theme: blackTheme,
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
