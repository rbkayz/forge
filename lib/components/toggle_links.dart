import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';



class ToggleLinks extends StatefulWidget {
  const ToggleLinks({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  _ToggleLinksState createState() => _ToggleLinksState();
}

class _ToggleLinksState extends State<ToggleLinks> {
  final linksBox = Hive.box(Constants.linksBox);

  @override
  Widget build(BuildContext context) {
    bool isStored = linksBox.containsKey(widget.currentContact.id);

    ///--------------------------------------------------------------
    /// Deactivate the link
    ///--------------------------------------------------------------

    void _deActivateLink() async {

      ForgeLinks currentLink = linksBox.get(widget.currentContact.id);

      currentLink.isActive = false;

      await linksBox.put(currentLink.linkKey, currentLink);
      print('successfully deactivated ${currentLink.displayName}. Key is ${currentLink.linkKey}. Total n is ${linksBox.length}');

      setState(() {});
    }

    ///--------------------------------------------------------------
    /// Activate the Link
    ///--------------------------------------------------------------

    void _addLink() async {
      ForgeLinks currentLink = isStored ? linksBox.get(widget.currentContact.id) : ForgeLinks(
        displayName: widget.currentContact.displayName,
        id: widget.currentContact.id,
      );

      currentLink.isActive = true;

      //Setting the linkDates to an empty list if it is null
      if (currentLink.linkDates.isEmpty) {
        print('activated');
        currentLink.linkDates = [];
      }

      ///--------------------------------------------------------------
      /// TEST CODE
      ///--------------------------------------------------------------

      currentLink.linkDates = [];
      currentLink.linkDates.add(
          ForgeDates(
              meetingDate: DateUtils.dateOnly(DateTime.now().add(Duration(days: int.parse(currentLink.id)))),
              meetingType: 'Default',
              isComplete: false,
            linkid: currentLink.id,
          ));

      ///--------------------------------------------------------------
      /// TEST CODE
      ///--------------------------------------------------------------

      await linksBox.put(currentLink.linkKey, currentLink);

      print('successfully added ${currentLink.displayName}. Key is ${currentLink.linkKey}. Total n is ${linksBox.length}');

      setState(() {});
    }

    ///--------------------------------------------------------------
    /// Widget Return statements
    ///--------------------------------------------------------------

    if (isStored) {
      ForgeLinks currentLink = linksBox.get(widget.currentContact.id);

      if (currentLink.isActive) {
        return GestureDetector(
          onTap: _deActivateLink,
          child: const Icon(
            Icons.person,
            color: Constants.kPrimaryColor,
          ),
        );
      } else {
        return GestureDetector(
          onTap: _addLink,
          child: const Icon(
            Icons.person_outline,
            color: Constants.kSecondaryColor,
          ),
        );
      }
    } else {
      return GestureDetector(
        onTap: _addLink,
        child: const Icon(
          Icons.person_outline,
          color: Constants.kSecondaryColor,
        ),
      );
    }
  }
}
