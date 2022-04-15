
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/standalone/error.dart';
import 'package:forge/screens/standalone/login.dart';
import 'package:forge/services/navigator_service.dart';
import 'package:forge/utilities/bottom_navigation_items.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../components/appbar.dart';
import '../components/bottom_navigation_bar.dart';
import 'contacts_service.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  late Future boxFuture;

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
  void initState() {
    super.initState();
  }


  Future<bool> openLinksBox () async {
    await Hive.openBox(Constants.linksBox);
    return true;
  }

  Future<bool> openPreferencesBox () async {
    await Hive.openBox(Constants.tagsBox);
    return true;
  }


  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User?>(context);
    /*
    Returns login screen if current user is null
     */

    if (currentUser == null) {
      return const LoginScreen();
    }

    /*
    Returns Futurebuilder and navigates to main screen if not null
     */

    else {
      return FutureProvider<List<Contact>?>(
        create: (context) => AllContactsServices().getAllContacts(),
        initialData: [],
        child: FutureBuilder(
          future: Future.wait({openLinksBox(),openPreferencesBox()}),

          builder: (BuildContext context,
              AsyncSnapshot<List<bool>> snapshot) {

            if (snapshot.connectionState == ConnectionState.done) {

              if (snapshot.hasError) {
                return const ForgeError();
              }

              else {
                return const NavigatorPage();
              }

            }

            else {

              return Scaffold(
                appBar: const ForgeAppBar(showOptions: true,showSearch: true),
                body: Container(),
                bottomNavigationBar: ForgeBottomNavigationBar(currentTab: TabName.timeline, onSelectTab: (tab) {}),
              );

            }

         },
        ),
      );
    }
  }


}
