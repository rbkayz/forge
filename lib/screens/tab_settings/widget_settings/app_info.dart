import 'package:flutter/material.dart';

import '../../../components/appbar.dart';
import '../../../utilities/constants.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ForgeAppBar(title: 'App Info',),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width*0.5,
            child: Image.asset(Constants.forgeHeaderLogo),),

            SizedBox(height: 12,),

            const Text(Constants.version, style: TextStyle(fontSize: 14, wordSpacing: 1, color: Constants.kPrimaryColor), ),


            SizedBox(height: 12,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                  'Made with ❤ by yours truly \n(but also because I was too lazy to just call my friends)',
                textAlign: TextAlign.center,
              ),
            ),

          ],
        )
    );
  }
}
