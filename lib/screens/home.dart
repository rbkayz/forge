import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:forge/components/bottom_navigation_bar.dart';
import 'package:forge/screens/tab_links/links.dart';
import 'package:forge/screens/tab_settings/settings.dart';
import 'package:forge/screens/tab_timeline/timeline.dart';
import 'package:forge/services/auth.dart';
import 'package:hive/hive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../utilities/bottom_navigation_items.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TabName activeTab = TabName.links;

  /// Item scroll controller for timeline
  final itemController = ItemScrollController();

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
        return ForgeAppBar(showOptions: true,showSearch: true, customWidget1: AppBarAddDate(),customWidget2: AppBarScrolltoToday(itemController: itemController),);
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
                  children: [
                    TimelinePage(itemController: itemController,),
                    LinksPage(),
                    SettingsPage(),
                  ],
                ),
                bottomNavigationBar: ForgeBottomNavigationBar(currentTab: activeTab, onSelectTab: _selectTab),
        ),
    );
  }


}
