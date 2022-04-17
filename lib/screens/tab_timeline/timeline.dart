import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/screens/tab_timeline/widget_timeline.dart';
import 'package:intl/intl.dart';
import 'package:forge/services/links_service.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import '../../components/loader.dart';
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
  final itemController = GroupedItemScrollController();

  ///--------------------------------------------------------------
  /// InitState
  ///--------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  Future scrollToItem() async {
    print('yes');
    itemController.scrollTo(index: 6, duration: Duration(milliseconds: 500));
  }

  ///--------------------------------------------------------------
  /// Build method
  ///--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
        valueListenable: linksBox.listenable(),
        builder: (BuildContext context, Box links, Widget? child) {
          dates = LinkDateServices().sortAllDates(links.values);

          List<Contact>? contacts = Provider.of<List<Contact>?>(context);

          return (contacts == null || contacts.isEmpty)

              ? const Center(
                  child: ForgeSpinKitRipple(
                  size: 100,
                  color: Constants.kPrimaryColor,
                ))


            //   : StickyGroupedListView<ForgeDates, DateTime>(
            //         elements: dates,
            //         groupBy: (element) => element.meetingDate!,
            //         itemBuilder: (context, element) {
            //           return LinkDateTile(date: element);
            //         },
            // itemScrollController: itemController,
            //         groupSeparatorBuilder: (value) => DateDivider(divText: DateFormat('EEE, d MMM').format(value.meetingDate!).toUpperCase()),
            //       );

          :ScrollablePositionedList.separated(
              itemCount: dates.length + 2,
              itemBuilder: (context, index) {
                if (index > 0 && index < dates.length + 1) {
                  return LinkDateTile(date: dates[index-1]);
                } else {return SizedBox.shrink();}
              },

              separatorBuilder: (context, index) {

                if (index == 0) {
                  return DateDivider(divText: DateFormat('EEE, d MMM').format(dates[index].meetingDate!).toUpperCase());
                } else if (index > 0 && index < dates.length) {
                  if (dates[index-1].meetingDate! != dates[index].meetingDate!) {
                    return DateDivider(divText: DateFormat('EEE, d MMM').format(dates[index].meetingDate!).toUpperCase());
                  } else {return SizedBox.shrink();}
                } else {return SizedBox.shrink();}

              }
              );



        });
  }
}
