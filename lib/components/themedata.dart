import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';

class ForgeTheme{

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Constants.kPrimaryColor,
      primarySwatch: Palette.forgePurple,
      scaffoldBackgroundColor: Constants.kWhiteColor,
      fontFamily: 'Roboto',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Constants.kWhiteColor,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(color: Constants.kPrimaryColor),
        headline6: TextStyle(color: Constants.kPrimaryColor)
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Constants.kWhiteColor,
        foregroundColor: Constants.kPrimaryColor,
        elevation: 0.2,
      )
    );
  }
}