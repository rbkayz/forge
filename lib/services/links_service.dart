import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/links_model.dart';
import 'auth.dart';

///--------------------------------------------------------------
/// LINK DATE SERVICES
///
/// Contains all the functions required to add, remove, modify
/// [ForgeLinks] and [ForgeDates]
///
///--------------------------------------------------------------

class LinkDateServices {


  /// Deactivates a link
  static Future<void> deactivateLink(String id, BuildContext context) async {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

    ForgeLinks currentLink = linksBox.get(id);
    currentLink.isActive = false;

    HapticFeedback.lightImpact();

    await linksBox.put(currentLink.linkKey, currentLink);

  }


  /// Activates a link
  static Future<void> activateLink(BuildContext context, String id) async {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

    bool isStored = linksBox.containsKey(id);

    ForgeLinks currentLink = isStored ? linksBox.get(id) : ForgeLinks(
      id: id,
      isActive: true,
    );

    currentLink.isActive = true;


    if (currentLink.linkDates.isEmpty) {
      currentLink.linkDates = [];
    }

    HapticFeedback.lightImpact();
    await linksBox.put(currentLink.linkKey, currentLink);
  }


  /// Cycles through each link and gets all dates, and sorts it
  static List<ForgeDates> sortAllDates(value, {bool showAllDate = true}) {

    List<ForgeDates> sortDates = [];

    /// Iterates through list and adds all active dates to the [sortDates] list
    value.cast<ForgeLinks>().forEach((element) {
      if (element.isActive) {
        element.linkDates.forEach((e) {
          sortDates.add(e);
        });
      }
    });

    /// sorts the list based on the meeting dates
    sortDates.sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!));

    /// Checks for the showAllDate toggle. Returns only incomplete dates if set to false, else returns all
    if (showAllDate == false) {
      sortDates = sortDates.where((element) => element.isComplete == false).toList();
    }

    return sortDates;
  }


  /// Compare a map to the map of dates, and return a date
  static ForgeDates getDateFromMap(linklist, Map<String, dynamic> mapval) {

    late ForgeDates foundDate;
    List<ForgeDates> sortDates = [];

    /// Iterates through list and adds all active dates to the [sortDates] list
    linklist.cast<ForgeLinks>().forEach((ForgeLinks element) {
      if (element.isActive) {
        for (var e in element.linkDates) {
          sortDates.add(e);
        }
      }
    });

    /// Searches for the date that matches the map of the date in the function parameter
    foundDate =
        sortDates
            .where((element) => mapEquals(element.toMap(), mapval))
            .first;

    return foundDate;
  }


  /// Toggle Checkbox
  static void onTapCheckbox(bool? newValue, ForgeDates currentDate, BuildContext context) async {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

    /// finds the link based on id
    ForgeLinks currentLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == currentDate.linkid)
        .first;

    /// Sets the lin
    currentLink.linkDates
        .where((element) => element.hashCode == currentDate.hashCode)
        .first
        .isComplete = newValue;


    if (newValue == true) {
      /// Creates the next meeting date based on recurring criteria.
      ForgeDates? newDate = createNextMeeting(currentLink.id, context);

      if (newDate != null) {
        currentLink.linkDates.add(newDate);
      }


      /// Creates the next annual date e.g. birthday or anniversary
      if (currentDate.annual == true) {
        ForgeDates? newDate2 = createNextAnnualDate(currentLink.id, currentDate, context);

        if (newDate2 != null) {
          currentLink.linkDates.removeWhere((element) => element.hashCode == currentDate.hashCode);
          currentLink.linkDates.add(newDate2);
        }
      }
    }

    await linksBox.put(currentLink.linkKey, currentLink);
  }



  /// Get Link from ID. If not found, then returns null
  static ForgeLinks? getLinkfromid(String id, BuildContext context) {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

    if (doesLinkExist(id, context)) {
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
  static bool doesLinkExist(String id, BuildContext context) {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

    Iterable<ForgeLinks> foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id);

    return (foundLink.isNotEmpty);
  }


  /// Checks if link is active
  static bool isLinkActive(String id, BuildContext context) {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

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
  static ForgeDates getNextDate(String id, BuildContext context) {

    /// Checks if link exists
    bool linkExists = doesLinkExist(id, context);

    ForgeLinks? currentLink = getLinkfromid(id, context);

    /// Returns next date if link exists
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

    /// Returns an empty forgedates if link doesn't exist
    else {
      return ForgeDates();
    }
  }


  /// Get Prev Date that is complete
  static ForgeDates getPrevDate(String id, BuildContext context) {

    /// Checks if link exists
    bool linkExists = doesLinkExist(id, context);

    ForgeLinks? currentLink = getLinkfromid(id, context);

    /// Returns prev date if link exists
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

    /// Returns an empty forgedates if link doesn't exist
    else {
      return ForgeDates();
    }
  }


  /// Create a new recurring meeting if recurring ones and no active one is left
  static ForgeDates? createNextMeeting(String id, BuildContext context) {

    /// Checks if link exists
    bool linkExists = doesLinkExist(id, context);

    int addDays;

    ForgeLinks? currentLink = getLinkfromid(id, context);

    /// Returns next date if link exists
    if (linkExists && currentLink != null) {

      /// Checks is all dates are completed
      bool allCompleted = currentLink.linkDates.every((element) {
        return element.isComplete == true;
      });

      /// Returns true and proceeds only if all dates are completed
      if (allCompleted) {
        if (currentLink.recurringEnabled == true && currentLink.recurringNum != null && currentLink.recurringType != null) {
          List<ForgeDates> dates = currentLink.linkDates;

          /// Sorts the dates to get last date
          dates.sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!));

          /// Computes number of days if months or weeks
          if (currentLink.recurringType?.toLowerCase() == 'month(s)') {
            addDays = currentLink.recurringNum! * 30;
          } else {
            addDays = currentLink.recurringNum! * 7;
          }

          ForgeDates newDate = ForgeDates(
              meetingDate: dates.last.meetingDate!.add(Duration(days: addDays)), meetingType: 'Recurring meeting', isComplete: false, linkid: currentLink.id);

          return newDate;
        }
      }
    }

    return null;
  }


  /// Create a new recurring meeting if recurring ones and no active one is left
  static ForgeDates? createNextAnnualDate(String id, ForgeDates currentDate, BuildContext context) {

    // TODO FIX BIRTHDAY PRESS

    /// Checks if link exists
    bool linkExists = doesLinkExist(id, context);

    ForgeLinks? currentLink = getLinkfromid(id, context);



    /// Returns next date if link exists
    if (linkExists && currentLink != null) {
      currentDate.isComplete = false;

      if (currentDate.meetingDate != null) {

        int addyear = max(DateTime.now().year + 1, currentDate.meetingDate!.year + 1);

        /// Adds a year
        currentDate.meetingDate = DateTime(addyear, currentDate.meetingDate!.month, currentDate.meetingDate!.day);

        return currentDate;
      }
    }

    return null;
  }

}