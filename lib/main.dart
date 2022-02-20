import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forge/components/themedata.dart';
import 'package:forge/screens/onboarding/splash.dart';
import 'package:forge/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:forge/services/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
