import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forge/components/themedata.dart';
import 'package:forge/home.dart';
import 'package:forge/screens/login.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forge',
      theme: ForgeTheme.lightTheme,
      initialRoute: '/',
      routes: Navigate.routes,
      );
  }
}

class Navigate{
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => LoginScreen(),
    '/sign-in': (context) => LoginScreen(),
    '/home': (context) => Home()
  };
}