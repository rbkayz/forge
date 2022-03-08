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

    bool isActiveLink = linksBox.containsKey(widget.currentContact.id);
    ForgeLinks currentLink = ForgeLinks(displayName: widget.currentContact.displayName, id: widget.currentContact.id);

    //Add link and Delete link functions

    void _deleteLink() async {
      await linksBox.delete(currentLink.linkKey);
      print('successfully deleted ${currentLink.displayName}. Key is ${currentLink.linkKey}. Total n is ${linksBox.length}');

      setState(() {
        isActiveLink = !isActiveLink;
      });
    }

    void _addLink() async {
      await linksBox.put(currentLink.linkKey, currentLink);
      print('successfully added ${currentLink.displayName}. Key is ${currentLink.linkKey}. Total n is ${linksBox.length}');

      setState(() {
        isActiveLink = !isActiveLink;
      });
    }


    //Widget returns

    if(isActiveLink) {

      return GestureDetector(
        onTap: _deleteLink,
        child: const Icon(
          Icons.person,
          color: Constants.kPrimaryColor,
        ),
      );
    }

    else {

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