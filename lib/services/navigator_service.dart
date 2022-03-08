import 'package:flutter/material.dart';
import 'package:forge/services/router.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);


  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {

  Future<bool> _onPop() async {
    return !await Navigator.maybePop(NavigatorKeys.homeKey.currentState!.context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Navigator(
        key: NavigatorKeys.homeKey,
        onGenerateRoute: RouteGenerator.generateRouteHome,
      ),
    );
  }
}
