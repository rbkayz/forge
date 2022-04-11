import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/phone.dart';

class Constants {
  //colors
  static const Color kPrimaryColor = Color(Palette.forgePurplePrimaryValue); //Color.fromRGBO(103, 80, 164, 1);
  static const Color kBlackColor = Colors.black;
  static const Color kSecondaryColor = Colors.grey;
  static const Color kGreyColor = Colors.black12;
  static const Color kWhiteColor = Colors.white;
  static const Color kErrorColor = Color(0xffb3261e);

  //fonts
  static const headerFont = 'Redressed';

  //images
  static const forgeLogo = 'assets/images/forge-logo.png';
  static const googleLogo = 'assets/images/google-logo.png';
  static const forgeHeaderLogo = 'assets/images/forge-header-logo.png';
  static const errorImage = 'assets/images/error.png';
  static const repeatImage = 'assets/images/RepeatIcon.png';
  static const calendarImage = 'assets/images/calendar_container.png';

  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';
  static const wrapperNavigate = '/wrapper';
  static const contactDetailNavigate = 'contact-detail-navigate';
  static const errorNavigate = '/error';
  static const allContactsNavigate = '/home/all-contacts';
  static const helpCenterNavigate = '/home/settings/help-center';

  static const linksBox = 'links';

  //statusBarColor
  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kWhiteColor,
      statusBarIconBrightness: Brightness.dark);

  //Map Phone Label to String

  static const Map<PhoneLabel, String> phoneLabelToString = {
    PhoneLabel.assistant: 'assistant',
    PhoneLabel.callback: 'callback',
    PhoneLabel.car: 'car',
    PhoneLabel.companyMain: 'companyMain',
    PhoneLabel.faxHome: 'faxHome',
    PhoneLabel.faxOther: 'faxOther',
    PhoneLabel.faxWork: 'faxWork',
    PhoneLabel.home: 'home',
    PhoneLabel.iPhone: 'iPhone',
    PhoneLabel.isdn: 'isdn',
    PhoneLabel.main: 'main',
    PhoneLabel.mms: 'mms',
    PhoneLabel.mobile: 'mobile',
    PhoneLabel.pager: 'pager',
    PhoneLabel.radio: 'radio',
    PhoneLabel.school: 'school',
    PhoneLabel.telex: 'telex',
    PhoneLabel.ttyTtd: 'ttyTtd',
    PhoneLabel.work: 'work',
    PhoneLabel.workMobile: 'workMobile',
    PhoneLabel.workPager: 'workPager',
    PhoneLabel.other: 'other',
    PhoneLabel.custom: 'custom',
  };


  static const Map<EmailLabel, String> emailLabelToString = {
    EmailLabel.home: 'home',
    EmailLabel.iCloud: 'iCloud',
    EmailLabel.mobile: 'mobile',
    EmailLabel.school: 'school',
    EmailLabel.work: 'work',
    EmailLabel.other: 'other',
    EmailLabel.custom: 'custom',
  };

}


class Palette {
  static const MaterialColor forgePurple = MaterialColor(
    forgePurplePrimaryValue, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffeaddff),//10%
      100: Color(0xffd0bcff),//20%
      200: Color(0xffb69df8),//30%
      300: Color(0xff9a82db),//40%
      400: Color(0xff7f67be),//50%
      500: Color(forgePurplePrimaryValue),//60%
      600: Color(0xff4f378b),//70%
      700: Color(0xff381e72),//80%
      800: Color(0xff21005d),//90%
      900: Color(0xff000000),//100%
    },
  );

  static const int forgePurplePrimaryValue = 0xff6750a4;
}


class Months {
  static const List intToMonths = <String>[
    'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'

  ];
}

