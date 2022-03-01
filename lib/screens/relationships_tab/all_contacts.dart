import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {

  @override
  Widget build(BuildContext context) {

    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    return (contacts == null || contacts.isEmpty) ? const Center(child: ForgeSpinKitRipple(size: 50, color: Constants.kPrimaryColor,)) : Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: ContactListBuilder(contacts: contacts,)
      );
  }
}


class ContactListBuilder extends StatelessWidget {
  const ContactListBuilder({Key? key, required this.contacts}) : super(key: key);

  final List<Contact>? contacts;

  String getInitials(List<String> nameparts) {
    try {
      if(nameparts.length > 1) {
        return nameparts[0].characters.first.toUpperCase() + nameparts[1].characters.first.toUpperCase();
      }
      else if (nameparts.length == 1) {
        return nameparts[0].characters.first.toUpperCase();
      }
      else {
        return '-';
      }
    } on Exception catch (e) {
      print(e.toString());
      return '-';
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: contacts!.length,
      itemBuilder: (context, index) {
        Contact currentContact = contacts![index];
        Uint8List? currentContactImage = currentContact.photoOrThumbnail;
        String currentContactPhone = currentContact.phones.isNotEmpty ? currentContact.phones.first.number : '----------';
        List<String> nameparts = currentContact.displayName.split(" ");
        String initials = getInitials(nameparts);
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Constants.contactDetailNavigate, arguments: currentContact);
          },
          child: ListTile(
            leading: (currentContactImage == null) ? CircleAvatar(child: Text(initials),) : CircleAvatar(backgroundImage: MemoryImage(currentContactImage)),
            title: Text(currentContact.displayName),
            subtitle: Text(currentContactPhone),
          ),
        );
      },
    );
  }
}
