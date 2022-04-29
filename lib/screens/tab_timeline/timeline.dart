import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/screens/tab_timeline/widget_timeline.dart';
import 'package:intl/intl.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../components/loader.dart';
import '../../services/listenables.dart';
import '../../utilities/constants.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, required this.itemController}) : super(key: key);

  final ItemScrollController itemController;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  List<ForgeDates> dates = [];

  final linksBox = Hive.box(Constants.linksBox);
  final prefsBox = Hive.box(Constants.prefsBox);

  late Contact currentContact;



  @override
  Widget build(BuildContext context) {

    /// Listens to any changes in the box, and triggers a rebuild
    return ValueListenableBuilder2(
        first: linksBox.listenable(),
        second: prefsBox.listenable(),
        builder: (BuildContext context, Box links, Box prefs, Widget? child) {

          /// Receives a sorted list of meeting dates by parsing through each link
          dates = LinkDateServices.sortAllDates(links.values, showAllDate: prefs.get(Constants.showAllDatesinTimeline, defaultValue: true));

          /// Retrieves the list of contacts from the provider
          List<Contact>? contacts = Provider.of<List<Contact>?>(context);

          return (contacts == null || contacts.isEmpty)

                /// Returns a loading widget if contacts is empty or null
              ? const Center(
                  child: ForgeSpinKitRipple(
                  size: 100,
                  color: Constants.kPrimaryColor,
                ))


              /// Returns a scrollable list of date tiles, grouped and seperated by dates
            : ScrollablePositionedList.separated(

              /// Add two items to the list length to add empty boxes at start and end
              itemCount: dates.length + 2,

              /// Sets a scroll controller to scroll to any date
              itemScrollController: widget.itemController,

              /// Builds a linkdate tile except at first and last index
              itemBuilder: (context, index) {
                if (index > 0 && index < (dates.length + 1)) {

                  return LinkDateTile(date: dates[index-1]);
                }
                else {
                  return const SizedBox.shrink();
                }
              },

              /// Builds a separator. If index is 0, returns the date of the first widget.
              /// If index is >0, and <list length, then it checks if the previous list item has same date as current item. If yes, then doesn't build anything
              /// If no, then it builds a separator of the current date
              separatorBuilder: (context, index) {

                if (index == 0 && dates.isNotEmpty) {
                  return DateDivider(divText: DateFormat('EEE, d MMM y').format(dates[index].meetingDate!).toUpperCase());
                }

                else if (index > 0 && index < dates.length) {
                  if (dates[index-1].meetingDate! != dates[index].meetingDate!) {
                    return DateDivider(divText: DateFormat('EEE, d MMM y').format(dates[index].meetingDate!).toUpperCase());
                  }

                  else {return const SizedBox.shrink();}
                }

                else {return const SizedBox.shrink();}

              }
              );

        });
  }
}
