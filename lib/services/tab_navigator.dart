
import 'package:flutter/material.dart';
import 'package:forge/utilities/bottom_navigation_items.dart';
import 'package:forge/screens/relationships.dart';
import 'package:forge/screens/timeline.dart';

class TabNavigatorRoutes {
  static const String timeline = '/timeline';
  static const String relationships = '/relationships';
  static const String settings = '/settings';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {Key? key, required this.navigatorKey, required this.tabName}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final TabName tabName;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.timeline: (context) => TimelinePage(),
      TabNavigatorRoutes.relationships: (context) => RelationshipsPage(),
      //TabNavigatorRoutes.settings: (context) => SettingsPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.timeline,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}