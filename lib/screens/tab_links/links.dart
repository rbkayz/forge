import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/services/contact_methods.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
        child: const Icon(Icons.person_add_alt_outlined),
        onPressed: () {
          NavigatorKeys.homeKey.currentState!
              .pushNamed(Constants.allContactsNavigate)
              .then((value) => setState(() {}));
        },
      ),
      body: LinkListView(linksValues: linksValues),
    );
  }
}

class LinkListView extends StatelessWidget {
  LinkListView({
    Key? key,
    required this.linksValues,
  }) : super(key: key);

  final List linksValues;
  Contact dummyContact = Contact();

  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    return (contacts == null || contacts.isEmpty)
        ? const Center(
            child: ForgeSpinKitRipple(
            size: 50,
            color: Constants.kPrimaryColor,
          ))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: linksValues.length,
            itemBuilder: (context, index) {
              ForgeLinks currentLink = linksValues.elementAt(index);

              Contact? currentContact = (contacts.isEmpty)
                  ? dummyContact
                  : contacts
                      .where((element) => element.id == currentLink.id)
                      .single;

              return LinkCard(
                  currentLink: currentLink, currentContact: currentContact);
            },
          );
  }
}

class LinkCard extends StatelessWidget {
  LinkCard({
    Key? key,
    required this.currentLink,
    required this.currentContact,
  }) : super(key: key);

  final ForgeLinks currentLink;
  Contact currentContact;
  bool isLongPressed = false;

  double cardHeight = 60;

  @override
  Widget build(BuildContext context) {
    return currentContact.displayName == ''
        ? const SizedBox.shrink()
        : Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            shadowColor: Constants.kPrimaryColor,
            elevation: 0.6,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: cardHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                          ContactCircleAvatar(currentContact: currentContact),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentContact.displayName,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            currentContact.phones.first.number,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
