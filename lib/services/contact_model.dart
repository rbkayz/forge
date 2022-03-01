import 'package:flutter_contacts/flutter_contacts.dart';

class ForgeContact {

  ForgeContact({required this.contact});

  Contact contact;

  /*
  Phone Numbers
   */

  int get phonesNum {
    return contact.phones.length;
  }


}