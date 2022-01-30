import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const ColorSwatch kPrimaryColor = Colors.deepPurple;
  static const Color kBlackColor = Colors.black;
  static const ColorSwatch kSecondaryColor = Colors.grey;
  static const Color kGreyColor = Colors.black12;
  static const Color kWhiteColor = Colors.white;


  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kWhiteColor,
      statusBarIconBrightness: Brightness.dark);
}