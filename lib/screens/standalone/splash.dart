import 'package:flutter/material.dart';
import 'package:forge/components/loader.dart';
import 'dart:async';
import 'package:forge/utilities/constants.dart';

class ForgeSplash extends StatefulWidget {
  const ForgeSplash({Key? key}) : super(key: key);

  @override
  _ForgeSplashState createState() => _ForgeSplashState();
}

class _ForgeSplashState extends State<ForgeSplash> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, Constants.wrapperNavigate);
  }

  @override
  Widget build(BuildContext context) {
    return const ForgeLoader();
  }
}
