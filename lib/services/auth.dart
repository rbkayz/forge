import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isLogged() async {
    try{
      final User? currentUser = await _auth.currentUser;
      return currentUser != null;
    } catch(e) {
      print('Error is $e');
      return false;

    }

  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);

  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<User?> get currentUser {
    return _auth.authStateChanges();
  }

  User? currentUserState() {
    return _auth.currentUser;
  }




  /// Box Name getters

  static String getLinksBox (BuildContext context) {

    final currentUser = Provider.of<User?>(context, listen: false);

    if (currentUser == null) {
      return Constants.linksBox;
    }

    else {

      final currentUserID = currentUser.uid;
      return '$currentUserID-links';

    }

  }


  static String getPrefsBox (BuildContext context) {

    final currentUser = Provider.of<User?>(context, listen: false);

    if (currentUser == null) {
      return Constants.prefsBox;
    }

    else {

      final currentUserID = currentUser.uid;
      return '$currentUserID-prefs';

    }

  }


}
