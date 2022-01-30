import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  List<Contact>? contacts = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> _contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {
        contacts = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (contacts == null) ? const Center(child: CircularProgressIndicator()) : Container(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child:
          ListView.builder(
            shrinkWrap: true,
            itemCount: contacts!.length,
            itemBuilder: (context, index) {
              Contact currentContact = contacts![index];
              Uint8List? currentContactImage = currentContact.photoOrThumbnail;
              String currentContactPhone = currentContact.phones.isNotEmpty ? currentContact.phones.first.number : '----------';
              List<String> nameparts = currentContact.displayName.split(" ");
              String initials = nameparts[0].characters.first.toUpperCase() + nameparts[1].characters.first.toUpperCase();
              return ListTile(
                leading: (currentContactImage == null) ? CircleAvatar(child: Text(initials),) : CircleAvatar(backgroundImage: MemoryImage(currentContactImage)),
                title: Text(currentContact.displayName),
                subtitle: Text(currentContactPhone),
              );
            },
          ),
      );
  }
}
