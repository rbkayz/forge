import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/!garage/error_message.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () async {
            FirebaseAuthService auth = FirebaseAuthService();
            try{
              await auth.signOutFromGoogle();
              //Navigator.pushReplacementNamed(context, Constants.signInNavigate);

            }catch(e) {
              if(e is FirebaseAuthException){
                Navigator.pushReplacementNamed(context, Constants.errorNavigate);
              }
            }
          },
          child: const Text('Logout from Google')),
    );
  }

  @override
  void dispose() {
    Hive.box(Constants.linksBox).close();
    super.dispose();
  }
}
