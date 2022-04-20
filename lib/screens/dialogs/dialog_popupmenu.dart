import 'package:flutter/material.dart';
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

    bool showAllDates = prefsBox.get('showAllDatesInTimeline', defaultValue: true);

    return PopupMenuButton(
      onSelected: (val) {

        if (val == 1) {
          setState(() {

            showAllDates = !showAllDates;
            prefsBox.put('showAllDatesInTimeline', showAllDates);
            print(prefsBox.get('showAllDatesInTimeline'));

          });
        }
      },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        itemBuilder: (context) =>
    [
      CheckedPopupMenuItem(
        padding: EdgeInsets.zero,
        checked: showAllDates,
        child: Text("First"),
        value: 1,
      ),
      const PopupMenuItem(
        child: Text("Second"),
        value: 2,
      )
    ]
    );
  }
}
