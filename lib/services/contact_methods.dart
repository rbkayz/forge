import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';


String getInitials(List<String> nameParts) {
  try {
    if (nameParts.length > 1) {
      return nameParts[0].characters.first.toUpperCase() +
          nameParts[1].characters.first.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0].characters.first.toUpperCase();
    } else {
      return '-';
    }
  } on Exception catch (e) {
    print(e.toString());
    return '-';
  }
}

class ContactCircleAvatar extends StatefulWidget {
  const ContactCircleAvatar({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  _ContactCircleAvatarState createState() => _ContactCircleAvatarState();
}

class _ContactCircleAvatarState extends State<ContactCircleAvatar> {
  @override
  Widget build(BuildContext context) {

    Uint8List? currentContactImage = widget.currentContact.photoOrThumbnail;
    List<String> nameParts = widget.currentContact.displayName.split(" ");
    String initials = getInitials(nameParts);

    return (currentContactImage == null) ? CircleAvatar(
    child: Text(initials),
    )
        : CircleAvatar(
    backgroundImage: MemoryImage(currentContactImage));
  }
}



