import 'package:flutter/material.dart';
import 'package:forge/utilities/constants.dart';

class LinksPage extends StatefulWidget {
  const LinksPage({Key? key}) : super(key: key);

  @override
  _LinksPageState createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: false).pushNamed(Constants.allContactsNavigate);
        }
    );
  }
}
