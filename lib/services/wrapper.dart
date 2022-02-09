import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forge/home.dart';
import 'package:forge/screens/login.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<User?>(context);

    return currentuser == null ? const LoginScreen() : const Home();
  }
}
