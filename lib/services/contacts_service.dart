import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

class AllContactsServices {

  List<Contact>? contacts = [];

  Future<List<Contact>?> getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {

      List<Contact> _contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      contacts = _contacts;

      return contacts;
    }
  }

  Contact getContactfromID(BuildContext context, String id) {

    Contact currentContact;
    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    currentContact = contacts!.where((element) => element.id == id).first;

    return currentContact;

  }


}