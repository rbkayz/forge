import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

class AllContactsServices {

  List<Contact>? contacts = [];

  /// Returns a future with list of contacts
  Future<List<Contact>?> getAllContacts() async {

    /// Requests the user for permission to access contacts on device
    if (await FlutterContacts.requestPermission()) {

      List<Contact> _contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      contacts = _contacts;

      return contacts;
    }
  }

  /// Returns a Contact object by passing an ID.
  Contact getContactfromID(BuildContext context, String id) {

    Contact currentContact;
    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    currentContact = contacts?.where((element) => element.id == id).first ?? Contact();

    return currentContact;

  }


}