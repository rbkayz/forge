import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';

part 'links_model.g.dart';

@HiveType(typeId: 0)
class ForgeLinks extends HiveObject {

  ForgeLinks({required this.contact, required this.id});

  @HiveField(0)
  String id;

  @HiveField(1)
  Contact contact;

  bool isActiveLink = false;

  String get linkKey {
    return contact.id;
  }

  Contact get linkContact {
    return contact;
  }



}
