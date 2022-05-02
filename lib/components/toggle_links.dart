import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/auth.dart';



class ToggleLinks extends StatefulWidget {
  const ToggleLinks({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  _ToggleLinksState createState() => _ToggleLinksState();
}

class _ToggleLinksState extends State<ToggleLinks> {




  /// Add Snack Bar
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
            mainAxisAlignment: MainAxisAlignment.center,
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




  @override
  Widget build(BuildContext context) {

    final linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));

      ForgeLinks? currentLink = linksBox.get(widget.currentContact.id);

      return ValueListenableBuilder(
            valueListenable: linksBox.listenable(),
            builder: (BuildContext context, Box links, Widget? child) => GestureDetector(

            onTap: () {

              if (currentLink != null && currentLink.isActive) {

                LinkDateServices.deactivateLink(widget.currentContact.id, context);

                ScaffoldMessenger.of(context).showSnackBar(
                    linkModNotification(false)
                );

              } else {

                LinkDateServices.activateLink(context, widget.currentContact.id);

                ScaffoldMessenger.of(context).showSnackBar(
                    linkModNotification(true)
                );

                LinkDateServices.createNextMeeting(widget.currentContact.id, context);

              }

              setState(() {});

            },

            child:  Icon(
                (currentLink != null && currentLink.isActive) ? Icons.person : Icons.person_outlined,
                color: (currentLink != null && currentLink.isActive) ? Constants.kPrimaryColor : Constants.kSecondaryColor
            ),
        ),
      );
    }
}
