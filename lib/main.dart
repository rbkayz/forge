import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forge/components/themedata.dart';
import 'package:forge/screens/onboarding/splash.dart';
import 'package:forge/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:forge/services/router.dart';

void main() async {

  /*
  Invoking the main function. Important to initialize firebase at the start
   */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*
    The StreamProvider calls a function in the FirebaseAuthService class
    (in auth.dart) that returns a stream of the current active user (based on
    listens to auth state changes)

    Streamprovider is available to all widgets in the entire tree, and
    navigates to the Splash screen
   */

    return StreamProvider<User?>.value(
      value: FirebaseAuthService().currentUser,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Forge',
        theme: ForgeTheme.lightTheme,
        home: const ForgeSplash(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
