import 'package:flutter/material.dart';


///--------------------------------------------------------------
/// Timeline Popup Menu
///--------------------------------------------------------------


class TimelinePopupMenu extends StatefulWidget {
  const TimelinePopupMenu({Key? key}) : super(key: key);

  @override
  State<TimelinePopupMenu> createState() => _TimelinePopupMenuState();
}

class _TimelinePopupMenuState extends State<TimelinePopupMenu> {

  late bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (val) {

        if (val == 1) {
          setState(() {
            print('pressed');
            _isSelected = !_isSelected;
          });
        }
      },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        itemBuilder: (context) =>
    [
      CheckedPopupMenuItem(
        padding: EdgeInsets.zero,
        checked: _isSelected,
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
