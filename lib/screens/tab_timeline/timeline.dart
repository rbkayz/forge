import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/screens/tab_timeline/widget_timeline.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loader.dart';
import '../../models/links_model.dart';
import '../../utilities/constants.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  List<ForgeDates> dates = [];
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
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    // currentContact = AllContactsProvider()
                    //     .GetContactfromID(context, dates[index].linkid!);

                    return LinkDateTile(date: dates[index]);
                  },
                );
        });
  }
}
