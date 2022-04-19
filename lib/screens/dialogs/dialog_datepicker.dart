import 'package:flutter/material.dart';
import 'package:forge/screens/dialogs/dialog_snackbar.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';

import '../../models/links_model.dart';

class DatePickerService {


  Future<DateTime?> changeDate(BuildContext context, String id) async {

    bool meetingExists = LinkDateServices().getNextDate(id).meetingDate != null;
    DateTime initialDate = LinkDateServices().getNextDate(id).meetingDate ?? DateUtils.dateOnly(DateTime.now());

    final DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateUtils.dateOnly(DateTime.now()),
        lastDate: initialDate.add(Duration(days: 1461),),
        helpText: meetingExists ? 'CHANGE DATE' : 'SET NEW MEETING DATE',
    );

    if (newDate != null && newDate != initialDate) {

      Box linksBox = Hive.box(Constants.linksBox);
      ForgeLinks? currentLink = LinkDateServices().getLinkfromid(id);

      if (currentLink != null) {


        if (meetingExists) {

          currentLink.linkDates
              .where((element) => element.meetingDate == initialDate)
              .first
              .meetingDate = newDate;

          ForgeSnackBar().showFloatingSnackBar(context, Text('Changed meeting date', style: TextStyle(color: Constants.kPrimaryColor,), textAlign: TextAlign.center,));

        }


        else {
          currentLink.linkDates.add(ForgeDates(
            meetingDate: newDate,
            meetingType: 'Recurring Meeting',
            linkid: id,
            isComplete: false
          ));

          ForgeSnackBar().showFloatingSnackBar(context, Text('Added new meeting date', style: TextStyle(color: Constants.kPrimaryColor),textAlign: TextAlign.center));

        }

        await linksBox.put(currentLink.linkKey, currentLink);

      }

    }
    return newDate;

  }

}