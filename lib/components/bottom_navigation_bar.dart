import 'package:flutter/material.dart';
import 'package:forge/models/bottom_navigation_items.dart';

class ForgeBottomNavigationBar extends StatelessWidget {
  const ForgeBottomNavigationBar({Key? key, required this.currentTab, required this.onSelectTab}) : super(key: key);

  final TabName currentTab;
  final ValueChanged<TabName> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          _buildItem(TabName.Timeline),
          _buildItem(TabName.Relationships),
          _buildItem(TabName.Settings),
        ],
      onTap: (index) {
          return onSelectTab(TabName.values[index]);},
      currentIndex: currentTab.index,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
    );
  }

  BottomNavigationBarItem _buildItem(TabName tab) {
    return BottomNavigationBarItem(
        label: tabLabel[tab],
        icon: Icon(tabIcon[tab]),
    );
  }

}
