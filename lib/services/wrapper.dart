
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/standalone/error.dart';
import 'package:forge/screens/standalone/login.dart';
import 'package:forge/screens/standalone/navigator_page.dart';
import 'package:forge/utilities/bottom_navigation_items.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../components/appbar.dart';
import '../components/bottom_navigation_bar.dart';
import 'contacts_service.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);


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


  /// Opens the links box, where all the links objects are stored
  Future<bool> openLinksBox () async {
    await Hive.openBox(Constants.linksBox);
    return true;
  }

  /// Opens the preferences box, where all common settings e.g. tags, notifications are stored
  Future<bool> openPreferencesBox () async {
    await Hive.openBox(Constants.prefsBox);
    return true;
  }


  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User?>(context);

    /// Returns login screen if current user is null
    if (currentUser == null) {
      return const LoginScreen();
    }


    /// Returns Futurebuilder and navigates to main screen if not null
    else {
      return FutureProvider<List<Contact>?>(

        /// Provider of a future (list of contacts) from the flutter_contacts service
        create: (context) => AllContactsServices().getAllContacts(),
        initialData: [],
        child: FutureBuilder(

          /// Calls two future functions which opens two boxes
          future: Future.wait({openLinksBox(),openPreferencesBox()}),

          builder: (BuildContext context,
              AsyncSnapshot<List<bool>> snapshot) {

            /// Wait for the future to completes. Proceeds when done
            if (snapshot.connectionState == ConnectionState.done) {

              /// Throws an error and navigates to error screen
              if (snapshot.hasError) {
                return const ForgeError();
              }

              /// Navigates to the Navigator Page
              else {
                return const NavigatorPage();
              }

            }

            else {

              /// Returns an empty home screen while the future is waiting to be completed
              return Scaffold(
                appBar: ForgeAppBar(),
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
