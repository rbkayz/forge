import 'package:hive/hive.dart';
import '../models/links_model.dart';
import '../utilities/constants.dart';

///--------------------------------------------------------------
/// Extension method to compare two dates
///--------------------------------------------------------------

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}


///--------------------------------------------------------------
/// Link Date Services Class
///--------------------------------------------------------------


class LinkDateServices {

  final linksBox = Hive.box(Constants.linksBox);
  List<ForgeDates> dates = [];


  ///--------------------------------------------------------------
  /// Concatenate all dates
  ///--------------------------------------------------------------

  List<ForgeDates> sortAllDates(value) {
    dates = [];
    value.cast<ForgeLinks>().forEach((element) {
      if (element.isActive) {
        element.linkDates.forEach((e) {
          dates.add(e);
        });
      }
    });

    dates.sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!));

    return dates;
  }



  ///--------------------------------------------------------------
  /// Toggle Checkbox
  ///--------------------------------------------------------------

  void onTapCheckbox (bool? newValue, ForgeDates currentDate) async {

    ForgeLinks currentLink = linksBox.values.cast<ForgeLinks>().where((element) => element.id == currentDate.linkid).first;

    currentLink.linkDates.where((element) => element.hashCode == currentDate.hashCode).first.isComplete = newValue;

    await linksBox.put(currentLink.linkKey, currentLink);

  }



}