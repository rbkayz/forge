import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:forge/components/bottom_navigation_bar.dart';
import '../utilities/bottom_navigation_items.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /// Sets the active tab at start of app
  TabName activeTab = TabName.timeline;

  /// Function that sets the selected tab as the active tab, and calls rebuild
  void _selectTab(TabName tab){
    setState(() {
      activeTab = tab;
    });
  }

  /// Future that returns [false] to any calls for screen pops
  Future<bool> _onPop() async {
    return false;
      //!await Navigator.maybePop(NavigatorKeys.homeKey.currentState!.context);
  }

  /// Modifies the app bar options based on the active tab
  PreferredSizeWidget ForgeAppBarSelector(TabName activeTab) {
    switch (activeTab) {

      case TabName.timeline: {
        return ForgeAppBar(showOptions: true,showSearch: true, customWidget1: AppBarAddDate(),);
      }

      case TabName.links: {
        return ForgeAppBar(showOptions: true,showSearch: true, customWidget1: AppBarAddLink(),);
      }

      case TabName.settings: {
        return ForgeAppBar(showOptions: true,showSearch: true);
      }

    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: _onPop,

      child: Scaffold(
                appBar: ForgeAppBarSelector(activeTab),
                body: IndexedStack(
                  index: activeTab.index,
                  children: tabPage.entries.map((e) => e.value).toList(),
                ),
                bottomNavigationBar: ForgeBottomNavigationBar(currentTab: activeTab, onSelectTab: _selectTab),
        ),
    );
  }


}
