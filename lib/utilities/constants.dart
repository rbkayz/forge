import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const Color kPrimaryColor = Color.fromRGBO(103, 80, 164, 1);
  static const Color kBlackColor = Colors.black;
  static const Color kSecondaryColor = Colors.grey;
  static const Color kGreyColor = Colors.black12;
  static const Color kWhiteColor = Colors.white;

  static const headerFont = 'Redressed';

  static const forgeLogo = 'assets/images/forge-logo.png';
  static const googleLogo = 'assets/images/google-logo.png';
  static const forgeHeaderLogo = 'assets/images/forge-header-logo.png';

  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';
  static const wrapperNavigate = '/wrapper';
  static const contactdetailNavigate = 'contact-detail';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kWhiteColor,
      statusBarIconBrightness: Brightness.dark);
}


class Palette {
  static const MaterialColor forgePurple = MaterialColor(
    0xff6750a4, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0x0d6750a4),//10%
      100: Color(0x336750a4),//20%
      200: Color(0x666750a4),//30%
      300: Color(0x996750a4),//40%
      400: Color(0xcc6750a4),//50%
      500: Color(0xff6750a4),//60%
      600: Color(0xff6750a4),//70%
      700: Color(0xff6750a4),//80%
      800: Color(0xff6750a4),//90%
      900: Color(0xff6750a4),//100%
    },
  );
}