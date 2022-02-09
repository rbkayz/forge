import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/services/error_message.dart';
import 'package:forge/utilities/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? currUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Constants.kWhiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Constants.statusBarColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/login_image.png"),
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
                    text: 'to build better relationships',
                    style: TextStyle(
                      color: Constants.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: size.width * 0.6,
                child: const Text(
                  '10k+ people use forge to keep in touch with their network ',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Constants.kSecondaryColor, fontSize: 14),
                ),
              ),
              SizedBox(height: size.height * 0.1),
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
    return isLoading ? const CircularProgressIndicator() : SizedBox(
      width: size.width*0.5,
      height: 40,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Constants.kWhiteColor),
          ),

        onPressed: () async {
            setState(() {
              isLoading = true;
            });

            FirebaseAuthService auth = FirebaseAuthService();
            try{
              await auth.signInWithGoogle();
              //Navigator.pushReplacementNamed(context, Constants.homeNavigate);

            }catch(e) {
              if(e is FirebaseAuthException){
                final err = ErrorMessage();
                err.showMessage(e.message!, context);
              }
            }

            setState(() {
              isLoading = false;
            });

          },

        child: Padding(
            padding: EdgeInsets.zero,
            child:Row(
              children: <Widget>[
               Container(
                 padding: EdgeInsets.zero,
                 width: 20,
                 height: 20,
                 child: Image.asset('assets/images/google-logo.png'),
               ),
                const SizedBox(width: 20,),
                Text('Sign in with Google',style: TextStyle(fontSize: 14, color: Colors.grey.shade600),),
              ]
            ),
      ),
      ),
    );
  }
}
