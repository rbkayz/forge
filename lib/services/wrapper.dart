import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/home.dart';
import 'package:forge/screens/onboarding/login.dart';
import 'package:provider/provider.dart';

import 'contacts_provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  /*
  Manages the overall navigation between LoginScreen and Home based on the
  login status of the user (receives via the StreamProvider in the root widget)

  Wrapper uses the AllContactsProvider class to receive a result from a
  future function (getAllContacts). Passes this into a FutureProvider which
  is then available across the widget tree.
   */

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User?>(context);

    if (currentUser == null) {
      return const LoginScreen();
    } else {
      return FutureProvider<List<Contact>?>(
        create: (context) => AllContactsProvider().getAllContacts(),
        initialData: [],
        child: const Home(),
      );
    }
  }
}
