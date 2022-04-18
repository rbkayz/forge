import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    /// Add Snack Bar
    ///--------------------------------------------------------------

    SnackBar linkModNotification (bool isActivated) {

      Text response = isActivated ? Text('Activated ${widget.currentContact.displayName}',overflow: TextOverflow.ellipsis, style:TextStyle(color: Constants.kPrimaryColor))
          : Text('Deactivated ${widget.currentContact.displayName}',overflow: TextOverflow.ellipsis, style:TextStyle(color: Constants.kSecondaryColor));
      Icon personIcon = isActivated ? const Icon(
        Icons.person,
        color: Constants.kPrimaryColor,
      ) : const Icon(
        Icons.person_outline,
        color: Constants.kSecondaryColor,
      );

      return SnackBar(duration: Duration(milliseconds : 1000),
        width: MediaQuery.of(context).size.width*0.6,
        padding: EdgeInsets.zero,
        backgroundColor: Constants.kWhiteColor,
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                personIcon,
                SizedBox(width: 5,),
                response,
              ],
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
      );

    }



    ///--------------------------------------------------------------
    /// Deactivate the link
    ///--------------------------------------------------------------

    void _deActivateLink() async {

      ForgeLinks currentLink = linksBox.get(widget.currentContact.id);

      currentLink.isActive = false;

      await linksBox.put(currentLink.linkKey, currentLink);

      ScaffoldMessenger.of(context).showSnackBar(
          linkModNotification(false)
      );

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

        currentLink.linkDates = [];
      }

      ///--------------------------------------------------------------
      /// Put this in the box
      ///--------------------------------------------------------------

      await linksBox.put(currentLink.linkKey, currentLink);

      ScaffoldMessenger.of(context).showSnackBar(
        linkModNotification(true)
      );

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
