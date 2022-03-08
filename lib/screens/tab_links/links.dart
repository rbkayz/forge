import 'package:flutter/material.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';

class LinksPage extends StatefulWidget {
  const LinksPage({Key? key}) : super(key: key);

  @override
  _LinksPageState createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  final linksBox = Hive.box(Constants.linksBox);
  List<dynamic> linksValues = [];

  @override
  Widget build(BuildContext context) {
    linksValues = linksBox.toMap().values.toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt_outlined),
        onPressed: () {
          NavigatorKeys.homeKey.currentState!
              .pushNamed(Constants.allContactsNavigate).then((value) => setState(() {}));
        },
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: linksValues.length,
        itemBuilder: (context, index) {
          ForgeLinks currentLink = linksValues.elementAt(index);
          return ListTile(
            title: Text(currentLink.displayName),
          );
        },
      ),
    );
  }
}
