import 'package:flutter/material.dart';
import 'package:forge/screens/relationships.dart';
import 'package:forge/screens/settings.dart';
import 'package:forge/screens/timeline.dart';

enum TabName {Timeline, Relationships, Settings}

const Map<TabName, String> tabLabel = {
  TabName.Timeline: 'Timeline',
  TabName.Relationships: 'Relationships',
  TabName.Settings: 'Settings',
};

const Map<TabName, IconData> tabIcon = {
  TabName.Timeline: Icons.ballot,
  TabName.Relationships: Icons.person,
  TabName.Settings: Icons.settings,
};

const Map<TabName, Widget> tabPage = {
  TabName.Timeline: TimelinePage(),
  TabName.Relationships: RelationshipsPage(),
  TabName.Settings: SettingsPage(),
};