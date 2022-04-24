import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:hive/hive.dart';
import '../models/links_model.dart';
import '../utilities/constants.dart';

///--------------------------------------------------------------
/// Link Date Services Class
///--------------------------------------------------------------

class LinkDateServices {
  final linksBox = Hive.box(Constants.linksBox);

  List<ForgeDates> sortDates = [];
  List<Map<String, dynamic>> mapListDates = [];



  /// Deactivate a link
  Future<void> deactivateLink(String id) async {
    ForgeLinks currentLink = linksBox.get(id);

    currentLink.isActive = false;

    HapticFeedback.lightImpact();

    await linksBox.put(currentLink.linkKey, currentLink);
  }



  /// Activate a link
  Future<void> activateLink(BuildContext context, String id) async {

    bool isStored = linksBox.containsKey(id);

    ForgeLinks currentLink = isStored ? linksBox.get(id) : ForgeLinks(
      id: id,
      isActive: true,
    );

    currentLink.isActive = true;

    //Setting the linkDates to an empty list if it is null
    if (currentLink.linkDates.isEmpty) {
      currentLink.linkDates = [];
    }

    HapticFeedback.lightImpact();
    await linksBox.put(currentLink.linkKey, currentLink);
  }




  /// Cycles through each link and gets all dates, and sorts it
  List<ForgeDates> sortAllDates(value, {bool showAllDate = true}) {
    value.cast<ForgeLinks>().forEach((element) {
      if (element.isActive) {
        element.linkDates.forEach((e) {
          sortDates.add(e);
        });
      }
    });

    sortDates.sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!));

    if (showAllDate == false) {
      sortDates = sortDates.where((element) => element.isComplete == false).toList();
    }

    return sortDates;

  }


  /// Compare a map to the map of dates, and return a date
  ForgeDates getDateFromMap(linklist, Map<String, dynamic> mapval) {
    late ForgeDates foundDate;
    sortDates = [];
    linklist.cast<ForgeLinks>().forEach((ForgeLinks element) {
      if (element.isActive) {
        element.linkDates.forEach((e) {
          sortDates.add(e);
        });
      }
    });

    foundDate =
        sortDates.where((element) => mapEquals(element.toMap(), mapval)).first;

    return foundDate;
  }


  /// Toggle Checkbox
  void onTapCheckbox(bool? newValue, ForgeDates currentDate) async {
    ForgeLinks currentLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == currentDate.linkid)
        .first;

    currentLink.linkDates
        .where((element) => element.hashCode == currentDate.hashCode)
        .first
        .isComplete = newValue;

    if (newValue == true) {

      ForgeDates? newDate = createNextMeeting(currentLink.id);

      if (newDate != null) {
        currentLink.linkDates.add(newDate);
      }

    }

    await linksBox.put(currentLink.linkKey, currentLink);
  }


  /// Get Link from ID
  ForgeLinks? getLinkfromid(String id) {

    if (doesLinkExist(id)) {

    ForgeLinks foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id)
        .first;

    return foundLink;
  }

    else {
      return null;
    }
  }


  /// Checks if a link exists
  bool doesLinkExist(String id) {
    Iterable<ForgeLinks> foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id);

    return (foundLink.isNotEmpty);
  }



  /// Checks if link is active
  bool isLinkActive(String id) {
    Iterable<ForgeLinks> foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id);

    if (foundLink.isNotEmpty && foundLink.first.isActive) {
      return true;
    } else {
      return false;
    }

  }



  /// Get Next date that isn't complete
  ForgeDates getNextDate(String id) {

    // Checks if link exists
    bool linkExists = doesLinkExist(id);

    ForgeLinks? currentLink = getLinkfromid(id);

    // Returns next date if link exists
    if (linkExists && currentLink != null) {

      List<ForgeDates> nextDateList = currentLink.linkDates
          .where((element) =>
              element.isComplete == false &&
              element.meetingDate!
                      .compareTo(DateUtils.dateOnly(DateTime.now())) >=
                  0)
          .toList();

      nextDateList.isNotEmpty
          ? nextDateList
              .sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!))
          : null;

      ForgeDates nextDate =
          nextDateList.isNotEmpty ? nextDateList.first : ForgeDates();

      return nextDate;
    }

    // Returns an empty forgedates if link doesn't exist
    else {
      return ForgeDates();
    }
  }


  /// Get Prev Date that is complete
  ForgeDates getPrevDate(String id) {

    // Checks if link exists
    bool linkExists = doesLinkExist(id);

    ForgeLinks? currentLink = getLinkfromid(id);

    // Returns prev date if link exists
    if (linkExists && currentLink != null) {

      List<ForgeDates> prevDateList = currentLink.linkDates
          .where((element) =>
              element.isComplete == true &&
              element.meetingDate!
                      .compareTo(DateUtils.dateOnly(DateTime.now())) <=
                  0)
          .toList();

      prevDateList.isNotEmpty
          ? prevDateList
              .sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!))
          : null;

      ForgeDates prevDate =
          prevDateList.isNotEmpty ? prevDateList.last : ForgeDates();

      return prevDate;
    }

    // Returns an empty forgedates if link doesn't exist
    else {
      return ForgeDates();
    }
  }



  /// Create a new recurring meeting if recurring ones and no active one is left
  ForgeDates? createNextMeeting (String id) {

    // Checks if link exists
    bool linkExists = doesLinkExist(id);

    int addDays;

    ForgeLinks? currentLink = getLinkfromid(id);

    // Returns next date if link exists
    if (linkExists && currentLink != null) {

      // Checks is all dates are completed
      bool allCompleted = currentLink.linkDates.every((element) => element.isComplete = true);

      if (allCompleted) {

        if (currentLink.recurringEnabled == true && currentLink.recurringNum != null && currentLink.recurringType != null) {


          List<ForgeDates> dates = currentLink.linkDates;

          // Sorts the dates to get last date
          dates.sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!));


          // Computes number of days if months or weeks
          if (currentLink.recurringType?.toLowerCase() == 'month(s)') {

            addDays = currentLink.recurringNum! * 30;

          } else {

            addDays = currentLink.recurringNum! * 7;

          }


          ForgeDates newDate = ForgeDates(meetingDate: dates.last.meetingDate!.add(Duration(days: addDays)), meetingType: 'Recurring meeting', isComplete: false, linkid: currentLink.id);

          return newDate;

        }


      }


    }



  }




}
