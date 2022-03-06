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

  var list = <Widget>[];
  TabName activeTab = TabName.timeline;

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
