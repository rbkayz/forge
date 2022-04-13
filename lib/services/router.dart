import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/screens/tab_links/contacts_screens/all_contacts.dart';
import 'package:forge/screens/standalone/error.dart';
import 'package:forge/screens/tab_links/contacts_screens/contact_header.dart';
import 'package:forge/screens/standalone/login.dart';
import 'package:forge/screens/home.dart';
import 'package:forge/screens/tab_settings/help_center.dart';
import 'package:forge/screens/tab_settings/widget_settings/edit_tags.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/utilities/constants.dart';
import 'package:forge/services/wrapper.dart';

class RouteGenerator {
  Future<bool?> loginStatus() async {
    await FirebaseAuthService().isLogged();
  }

  static Route<dynamic> generateRouteMain(RouteSettings settings) {
    switch (settings.name) {
      case Constants.wrapperNavigate:
        return MaterialPageRoute(builder: (context) => Wrapper());

      case Constants.signInNavigate:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case Constants.errorNavigate:
        return MaterialPageRoute(builder: (context) => const ForgeError());

      default:
        return MaterialPageRoute(
            builder: (context) => UndefinedView(
                  name: settings.name!,
                ));
    }
  }

  static Route<dynamic> generateRouteHome(RouteSettings settings) {

    switch (settings.name) {

      case '/':
        return MaterialPageRoute(builder: (context) => const Home());

      case Constants.homeNavigate:
        return MaterialPageRoute(builder: (context) => const Home());

      case Constants.allContactsNavigate:
        return MaterialPageRoute(builder: (context) => const AllContactsPage());

      case Constants.contactDetailNavigate:
        var currentContact = settings.arguments as Contact;
        return MaterialPageRoute(
            builder: (context) =>
                ContactDetail(currentContact: currentContact));

      case Constants.helpCenterNavigate:
        return MaterialPageRoute(builder: (context) => const HelpCenter());

      case Constants.editTagsNavigate:
        return MaterialPageRoute(builder: (context) => TagsEditor());

      default:
        return MaterialPageRoute(
            builder: (_) => UndefinedView(
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


class NavigatorKeys {
  static final GlobalKey<NavigatorState> mainKey = GlobalKey();
  static final GlobalKey<NavigatorState> homeKey = GlobalKey();


}