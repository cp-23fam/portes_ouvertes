import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/routing/app_router.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Portes ouvertes',
      theme: blackTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
