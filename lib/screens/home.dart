import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:forge/components/bottom_navigation_bar.dart';
import 'package:forge/services/navigator.dart';

import 'package:forge/services/router.dart';
import '../utilities/bottom_navigation_items.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  var list = <Widget>[];
  TabName activeTab = TabName.timeline;

  void _selectTab(TabName tab){
    setState(() {
      activeTab = tab;
    });
  }

  Future<bool> _onPop() async {
    return !await Navigator.maybePop(navHomeKeys.values.elementAt(activeTab.index).currentState!.context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: _onPop,

      child: Scaffold(
              appBar: const ForgeAppBar(),
              body: IndexedStack(
                index: activeTab.index,
                children: <Widget>[
                  NavigatorPage(navigatorKey:navHomeKeys.values.elementAt(0), child: tabPage.values.elementAt(0)),
                  NavigatorPage(navigatorKey:navHomeKeys.values.elementAt(1), child: tabPage.values.elementAt(1)),
                  NavigatorPage(navigatorKey:navHomeKeys.values.elementAt(2),child: tabPage.values.elementAt(2)),
                ],
              ),
              bottomNavigationBar: ForgeBottomNavigationBar(currentTab: activeTab, onSelectTab: _selectTab),
      ),
    );
  }


}
