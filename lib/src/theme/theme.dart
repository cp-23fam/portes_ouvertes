import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';

// Black
class AppColors {
  static Color firstColor = const Color.fromARGB(255, 155, 155, 155);
  static Color secondeColor = const Color.fromRGBO(217, 217, 217, 0.5);
  static Color thirdColor = const Color.fromRGBO(120, 120, 120, 0.4);
  static Color fourthColor = const Color.fromRGBO(65, 65, 65, 1);
  static Color fifthColor = const Color.fromRGBO(45, 45, 45, 1);

  static Color titleColor = const Color.fromARGB(255, 255, 255, 255);
  static Color textColor = const Color.fromARGB(255, 255, 255, 255);
  static Color smallTextColor = const Color.fromARGB(255, 209, 209, 209);
  static Color iconColor = const Color.fromARGB(255, 255, 255, 255);

  static Color goodColor = const Color.fromRGBO(30, 168, 23, 1);
  static Color specialColor = const Color.fromRGBO(47, 0, 127, 1);
  static Color hostColor = const Color.fromRGBO(230, 200, 30, 1);
  static Color deleteColor = const Color.fromRGBO(168, 23, 23, 1);
}

ThemeData blackTheme = ThemeData(
  // seed color
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.firstColor),

  // scaffold color
  scaffoldBackgroundColor: AppColors.fifthColor,

  // app bar theme colors
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.fourthColor,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  // text
  textTheme: const TextTheme().copyWith(
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
    ),
    headlineMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    titleMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),

  // card theme
  cardTheme: CardThemeData(
    color: AppColors.thirdColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(Sizes.p4),
    ),
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: Sizes.p16),
  ),

  // input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.thirdColor.withValues(alpha: 0.5),
    border: InputBorder.none,
    labelStyle: TextStyle(color: AppColors.textColor),
    prefixIconColor: AppColors.textColor,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(AppColors.fourthColor),
      // textStyle: TextStyle(color: )
    ),
  ),

  iconTheme: IconThemeData(color: AppColors.iconColor, size: Sizes.p32),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all<Color>(AppColors.iconColor),
      iconSize: WidgetStateProperty.all<double>(Sizes.p32),
    ),
  ),
);
