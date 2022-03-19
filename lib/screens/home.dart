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
  TabName activeTab = TabName.links;

  void _selectTab(TabName tab){
    setState(() {
      activeTab = tab;
    });
  }

  Future<bool> _onPop() async {
    return false;
      //!await Navigator.maybePop(NavigatorKeys.homeKey.currentState!.context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: _onPop,

      child: Scaffold(
              appBar: const ForgeAppBar(showOptions: true,showSearch: true),
              body: IndexedStack(
                index: activeTab.index,
                children: tabPage.entries.map((e) => e.value).toList(),
              ),
              bottomNavigationBar: ForgeBottomNavigationBar(currentTab: activeTab, onSelectTab: _selectTab),
      ),
    );
  }


}
