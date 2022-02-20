import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/home.dart';
import 'package:forge/screens/onboarding/login.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  List<Contact>? contacts = [];

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
    final currentuser = Provider.of<User?>(context);

    if(currentuser == null) {
      return const LoginScreen();
    } else {
      getAllContacts();
      return Provider<List<Contact>?>.value(
          value: contacts,
          child: const Home(),);
    }

}
}