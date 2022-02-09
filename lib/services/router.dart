import 'package:flutter/material.dart';
import 'package:forge/screens/login.dart';

import 'package:forge/home.dart';
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
        default:
          return MaterialPageRoute(
              builder: (context) => UndefinedView(name: settings.name!,));
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
