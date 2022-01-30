import 'package:flutter/material.dart';

import 'all_contacts.dart';

class RelationshipsPage extends StatefulWidget {
  const RelationshipsPage({Key? key}) : super(key: key);

  @override
  _RelationshipsPageState createState() => _RelationshipsPageState();
}

class _RelationshipsPageState extends State<RelationshipsPage> {
  @override
  Widget build(BuildContext context) {
    return AllContacts();
  }
}
