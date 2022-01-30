import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:forge/components/bottom_navigation_bar.dart';
import 'package:forge/screens/all_contacts.dart';
import 'package:forge/screens/relationships.dart';
import 'package:forge/screens/timeline.dart';
import 'package:forge/services/tab_navigator.dart';
import 'models/bottom_navigation_items.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var list = <Widget>[];
  TabName activeTab = TabName.Timeline;

  void _selectTab(TabName tab){
    setState(() {
      activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ForgeAppBar(),
        body: IndexedStack(
          index: activeTab.index,
          children: tabPage.entries.map((e) => e.value).toList(),
        ),
        bottomNavigationBar: ForgeBottomNavigationBar(currentTab: activeTab, onSelectTab: _selectTab),
    );
  }

}
