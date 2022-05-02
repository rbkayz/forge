import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/models/prefs_model.dart';
import 'package:forge/services/wrapper.dart';
import 'package:forge/utilities/themedata.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/services/auth.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:forge/services/router.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hive and register all adapters
  final forgeDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(forgeDocumentDirectory.path);

  Hive.registerAdapter(ForgeLinksAdapter());
  Hive.registerAdapter(ForgeDatesAdapter());
  Hive.registerAdapter(ForgePrefsAdapter());
  Hive.registerAdapter(LinkTagAdapter());

  /// Initialize awesome notifications
  await AwesomeNotifications().initialize('resource://drawable/forge_icon', [
    NotificationChannel(
      channelKey: 'Default',
      channelName: 'Default',
      importance: NotificationImportance.High, channelDescription: 'Daily Reminders',
    ),
  ],);


  /// Initialize Firebase
  await Firebase.initializeApp();

  /// Error Trap
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode)
      exit(1);
  };

  runApp(const ForgeApp());

}

class ForgeApp extends StatefulWidget {
  const ForgeApp({Key? key}) : super(key: key);

  @override
  State<ForgeApp> createState() => _ForgeAppState();
}

class _ForgeAppState extends State<ForgeApp> {

  late Mixpanel mixpanel;

  /// Initialize mixpanel
  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("c5e1335ca73861f4a93985fc7d2cf5d4", optOutTrackingDefault: false);
  }


  @override
  void initState() {
    super.initState();
    initMixpanel();
  }

  @override
  Widget build(BuildContext context) {

    ///--------------------------------------------------------------
    ///     The StreamProvider calls a function in the FirebaseAuthService class
    ///     (in auth.dart) that returns a stream of the current active user (based on
    ///     listens to auth state changes)
    ///
    ///     Streamprovider is available to all widgets in the entire tree, and
    ///     navigates to the Splash screen
    ///--------------------------------------------------------------

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

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
