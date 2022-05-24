import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/utilities/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  /*
  Class creates the login screen. Returned when currentUser is null by the
  provider
   */

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.kWhiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Constants.statusBarColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Spacing of 4%, 4% total
              SizedBox(
                height: size.height * 0.04,
              ),

              //Image size of 25%, 29% total
              SizedBox(
                height: size.height*0.25,
                child: Image.asset(
                    Constants.forgeHeaderLogo,
                ),
              ),

              //Spacing of 10%, 39% total
              SizedBox(
                height: size.height*0.1
              ),

              //Formatted main text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: 'Your ',
                    style: TextStyle(
                      color: Constants.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: 'personal relationship manager ',
                    style: TextStyle(
                      color: Constants.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: 'to build better connections',
                    style: TextStyle(
                      color: Constants.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ]),
              ),

              //Spacing of 3%, in total
              SizedBox(height: size.height * 0.03),

              //Subtitle box
              SizedBox(
                width: size.width * 0.75,
                child: const Text(
                  'Thousands of people use forge to keep in touch with their friends, colleagues and mentors ',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Constants.kSecondaryColor, fontSize: 14),
                ),
              ),

              //Spacing of 10%, in total
              SizedBox(height: size.height * 0.1),

              //GoogleSignIn button
              const ForgeGoogleSignIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgeGoogleSignIn extends StatefulWidget {
  const ForgeGoogleSignIn({Key? key}) : super(key: key);

  @override
  _ForgeGoogleSignInState createState() => _ForgeGoogleSignInState();
}

class _ForgeGoogleSignInState extends State<ForgeGoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const ForgeSpinKitRipple(size: 50, color: Constants.kPrimaryColor,)
        : SizedBox(
            width: size.width * 0.5,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Constants.kWhiteColor),
              ),


              //onPressed functionality sets loading and signs into Firebase
              onPressed: () async {
                HapticFeedback.lightImpact();
                setState(() {
                  isLoading = true;
                });

                FirebaseAuthService auth = FirebaseAuthService();
                try {

                  await showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text(
                      'Contacts Usage Policy',
                      style:
                      TextStyle(color: Constants.kBlackColor),
                    ),
                    content: const Text(
                        'forge requests access to your contacts to make it easy for you to manage relationships. Please click accept, and allow contacts (next screen) to proceed'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            setState(() {
                              isLoading = false;
                            });

                          },
                          child: const Text('Decline',
                              style: TextStyle(
                                  color: Constants.kErrorColor))),
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await FlutterContacts.requestPermission();
                            await auth.signInWithGoogle();
                          },
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                                color: Constants.kPrimaryColor),
                          )),
                    ],
                  ));

                } catch (e) {
                  if (e is FirebaseAuthException) {
                    print(e.toString());
                  }
                }

                // setState(() {
                //   isLoading = false;
                // });
              },

              //GoogleSignInLogo in accordance to google guidelines
              child: Padding(
                padding: EdgeInsets.zero,
                child: Row(children: <Widget>[
                  Container(
                    padding: EdgeInsets.zero,
                    width: 20,
                    height: 20,
                    child: Image.asset(Constants.googleLogo),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ]),
              ),
            ),
          );
  }
}
