import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/services/error_message.dart';

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
                final err = ErrorMessage();
                err.showMessage(e.message!, context);
              }
            }
          },
          child: Text('Logout from Google')),
    );
  }
}
