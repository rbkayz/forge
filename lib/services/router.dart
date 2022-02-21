import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/screens/relationships_tab/contact_detail_tabs/contact_detail.dart';
import 'package:forge/screens/onboarding/login.dart';

import 'package:forge/screens/home.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/utilities/constants.dart';
import 'package:forge/services/wrapper.dart';

class RouteGenerator {
  Future<bool?> loginStatus() async {
    await FirebaseAuthService().isLogged();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constants.wrapperNavigate:
        return MaterialPageRoute(builder: (context) => const Wrapper());
      case Constants.homeNavigate:
        return MaterialPageRoute(builder: (context) => const Home());
      case Constants.signInNavigate:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case Constants.contactdetailNavigate:
        var currentContact = settings.arguments as Contact;
        return MaterialPageRoute(
            builder: (context) =>
                ContactDetail(currentContact: currentContact));
      default:
        return MaterialPageRoute(
            builder: (context) => UndefinedView(
                  name: settings.name!,
                ));
    }
  }
}

class UndefinedView extends StatelessWidget {
  final String name;

  const UndefinedView({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
