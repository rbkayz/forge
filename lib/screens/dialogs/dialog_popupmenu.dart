import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../utilities/constants.dart';

///--------------------------------------------------------------
/// Timeline Popup Menu
///--------------------------------------------------------------

class TimelinePopupMenu extends StatefulWidget {
  const TimelinePopupMenu({Key? key}) : super(key: key);

  @override
  State<TimelinePopupMenu> createState() => _TimelinePopupMenuState();
}

class _TimelinePopupMenuState extends State<TimelinePopupMenu> {
  Box prefsBox = Hive.box(Constants.prefsBox);

  @override
  Widget build(BuildContext context) {
    bool showAllDates =
        prefsBox.get(Constants.showAllDatesinTimeline, defaultValue: true);
    String sortLinkMethod = prefsBox.get(Constants.sortLinkMethod,
        defaultValue: Constants.sortbyDate);

    return PopupMenuButton(
        onSelected: (val) {},

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        itemBuilder: (context) => [

              /// Toggles showing the dates vs not
              PopupMenuItem(
                  padding: EdgeInsets.zero,

                  /// Source: https://stackoverflow.com/questions/59760494/popupmenu-setstate-doesnt-update-flutter
                  /// Builds the timeline toggle
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) => SwitchListTile(
                        contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        value: showAllDates,
                        activeColor: Constants.kPrimaryColor,
                        title: const Text('Show completed'),
                        onChanged: (val) {

                          setState(() {

                            HapticFeedback.lightImpact();
                            showAllDates = !showAllDates;
                            prefsBox.put(
                                Constants.showAllDatesinTimeline, showAllDates);

                          });
                        }),
                  )),

              /// Builds the timeline toggle
              PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) => ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      title: const Text('Sort by'),
                      trailing: TextButton(
                        child: Text(sortLinkMethod),
                        onPressed: () {
                          setState(() {
                            HapticFeedback.lightImpact();
                            sortLinkMethod =
                                (sortLinkMethod == Constants.sortbyDate)
                                    ? Constants.sortbyName
                                    : Constants.sortbyDate;
                            prefsBox.put(
                                Constants.sortLinkMethod, sortLinkMethod);
                          });
                        },
                      ),
                    ),
                  ))
            ]);
  }
}
