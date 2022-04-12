import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/links_model.dart';
import '../utilities/constants.dart';

///--------------------------------------------------------------
/// Extension method to compare two dates
///--------------------------------------------------------------

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

///--------------------------------------------------------------
/// Link Date Services Class
///--------------------------------------------------------------

class LinkDateServices {
  final linksBox = Hive.box(Constants.linksBox);

  List<ForgeDates> sortDates = [];
  List<Map<String, dynamic>> mapListDates = [];

  Map<DateTime, List<ForgeDates>> map_dates = {};

  ///--------------------------------------------------------------
  /// Concatenate all dates
  ///--------------------------------------------------------------

  List<Map<String, dynamic>> sortAllDates(value) {
    value.cast<ForgeLinks>().forEach((element) {
      if (element.isActive) {
        element.linkDates.forEach((e) {
          mapListDates.add(e.toMap());
        });
      }
    });

    return mapListDates;
  }

  ///--------------------------------------------------------------
  /// Compare a map to the map of dates, and return a date
  ///--------------------------------------------------------------

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

  ///--------------------------------------------------------------
  /// Toggle Checkbox
  ///--------------------------------------------------------------

  void onTapCheckbox(bool? newValue, ForgeDates currentDate) async {
    ForgeLinks currentLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == currentDate.linkid)
        .first;

    currentLink.linkDates
        .where((element) => element.hashCode == currentDate.hashCode)
        .first
        .isComplete = newValue;

    await linksBox.put(currentLink.linkKey, currentLink);
  }

  ///--------------------------------------------------------------
  /// Get Link from ID
  ///--------------------------------------------------------------

  ForgeLinks getLinkfromid(String id) {
    ForgeLinks foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id)
        .first;

    return foundLink;
  }

  ///--------------------------------------------------------------
  /// Does a link exist
  ///--------------------------------------------------------------

  bool doesLinkExist(String id) {
    Iterable<ForgeLinks> foundLink = linksBox.values
        .cast<ForgeLinks>()
        .where((element) => element.id == id);

    return (foundLink.isNotEmpty);
  }

  ///--------------------------------------------------------------
  /// Get Next date that isn't complete
  ///--------------------------------------------------------------

  ForgeDates getNextDate(String id) {
    bool linkExists = LinkDateServices().doesLinkExist(id);

    if (linkExists) {
      ForgeLinks currentLink = LinkDateServices().getLinkfromid(id);

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
    } else {
      return ForgeDates();
    }
  }

  ///--------------------------------------------------------------
  /// Get Prev Date that is complete
  ///--------------------------------------------------------------

  ForgeDates getPrevDate(String id) {
    bool linkExists = LinkDateServices().doesLinkExist(id);

    if (linkExists) {
      ForgeLinks currentLink = LinkDateServices().getLinkfromid(id);

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
    } else {
      return ForgeDates();
    }
  }
}
