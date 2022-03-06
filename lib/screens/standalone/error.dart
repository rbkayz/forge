import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';

class ForgeError extends StatelessWidget {
  const ForgeError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(Constants.errorImage),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.04,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: const Center(
                  child: Text(
                    'Something snapped. Please try again',
                    style: TextStyle(
                      fontSize: 16,
                      color: Constants.kErrorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
}
