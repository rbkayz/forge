import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/models/tags_model.dart';
import 'package:forge/services/wrapper.dart';
import 'package:forge/utilities/themedata.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/services/auth.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:forge/services/router.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /*
  Initialize hive and open box;
  */

  final forgeDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(forgeDocumentDirectory.path);

  Hive.registerAdapter(ForgeLinksAdapter());
  Hive.registerAdapter(ForgeDatesAdapter());
  Hive.registerAdapter(ForgeTagsAdapter());
  Hive.registerAdapter(LinkTagAdapter());

  /*
  Initialize firebase and run app;
  */

  await Firebase.initializeApp();

  runApp(const ForgeApp());

}

class ForgeApp extends StatelessWidget {
  const ForgeApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    /*
    The StreamProvider calls a function in the FirebaseAuthService class
    (in auth.dart) that returns a stream of the current active user (based on
    listens to auth state changes)

    Streamprovider is available to all widgets in the entire tree, and
    navigates to the Splash screen
   */

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

    return StreamProvider<User?>.value(
      value: FirebaseAuthService().currentUser,
      initialData: FirebaseAuthService().currentUserState(),
      child: MaterialApp(
        navigatorKey: NavigatorKeys.mainKey,
        debugShowCheckedModeBanner: false,
        title: 'Forge',
        theme: ForgeTheme.lightTheme,
        home: Wrapper(),
        onGenerateRoute: RouteGenerator.generateRouteMain,
      ),
    );
  }
}
