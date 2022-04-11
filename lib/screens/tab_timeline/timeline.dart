import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/screens/tab_timeline/widget_timeline.dart';
import 'package:intl/intl.dart';
import 'package:forge/services/links_service.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/loader.dart';
import '../../utilities/constants.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<Map<String, dynamic>> dates = [];
  final linksBox = Hive.box(Constants.linksBox);
  late Contact currentContact;
  bool isLoaded = false;

  ///--------------------------------------------------------------
  /// InitState
  ///--------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  ///--------------------------------------------------------------
  /// Build method
  ///--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: linksBox.listenable(),
        builder: (BuildContext context, Box value, Widget? child) {
          dates = LinkDateServices().sortAllDates(value.values);

          List<Contact>? contacts = Provider.of<List<Contact>?>(context);

          return (contacts == null || contacts.isEmpty)

              ? const Center(
                  child: ForgeSpinKitRipple(
                  size: 50,
                  color: Constants.kPrimaryColor,
                ))


              : GroupedListView<dynamic, DateTime>(
                  elements: dates,
                  groupBy: (element) => element['meetingDate'],
                  itemBuilder: (context, element) {
                    return LinkDateTile(date: LinkDateServices().getDateFromMap(value.values, element));
                  },
                  groupSeparatorBuilder: (DateTime value) => DateDivider(divText: DateFormat('EEE, d MMM').format(value).toUpperCase()),
                );
        });
  }
}
