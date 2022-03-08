import 'package:flutter/material.dart';
import 'package:forge/screens/tab_links/links.dart';
import 'package:forge/screens/tab_settings/settings.dart';
import 'package:forge/screens/tab_timeline/timeline.dart';

enum TabName {timeline, links, settings}

const Map<TabName, String> tabLabel = {
  TabName.timeline: 'Timeline',
  TabName.links: 'Links',
  TabName.settings: 'Settings',
};

const Map<TabName, IconData> tabIcon = {
  TabName.timeline: Icons.ballot,
  TabName.links: Icons.people,
  TabName.settings: Icons.settings,
};

const Map<TabName, Widget> tabPage = {
  TabName.timeline: TimelinePage(),
  TabName.links: LinksPage(),
  TabName.settings: SettingsPage(),
};

Map<TabName, GlobalKey> navHomeKeys = {
  TabName.timeline: GlobalKey(),
  TabName.links: GlobalKey(),
  TabName.settings: GlobalKey(),
};