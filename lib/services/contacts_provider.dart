import 'package:flutter_contacts/flutter_contacts.dart';

class AllContactsProvider {

  List<Contact>? contacts = [];

  Future<List<Contact>?> getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> _contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      contacts = _contacts;
      return contacts;
    }
  }

}