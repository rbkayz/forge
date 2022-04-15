import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/screens/tab_links/widgets_links.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../services/contacts_service.dart';
import '../../services/links_service.dart';

class LinksPage extends StatefulWidget {
  const LinksPage({Key? key}) : super(key: key);

  @override
  _LinksPageState createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  final linksBox = Hive.box(Constants.linksBox);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add_alt_outlined),
        onPressed: () {
          NavigatorKeys.homeKey.currentState!
              .pushNamed(Constants.allContactsNavigate);
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: linksBox.listenable(),
        builder: (BuildContext context, Box value, Widget? child) {
          return LinkListView(linksValues: value.toMap().values.cast<ForgeLinks>().where((element) => element.isActive).toList());
        },
      ),
    );
  }
}

///--------------------------------------------------------------
/// List view for all the active links
///--------------------------------------------------------------

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
            size: 100,
            color: Constants.kPrimaryColor,
          ))
        : ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey.shade400,
              indent: 68,
              endIndent: 20,
              height: 1,
            ),
            shrinkWrap: true,
            itemCount: linksValues.length,
            itemBuilder: (context, index) {

              ForgeLinks currentLink = linksValues.elementAt(index);

              Contact? currentContact = (contacts.isEmpty)
                  ? dummyContact
                  : contacts
                      .where((element) => element.id == currentLink.id)
                      .single;

              return currentLink.isActive
                  ? LinkCard(currentID: currentContact.id)
                  : const SizedBox.shrink();
            },
          );
  }
}

///--------------------------------------------------------------
/// Card Widget
///--------------------------------------------------------------

class LinkCard extends StatefulWidget {
  LinkCard({
    Key? key,
    required this.currentID,
  }) : super(key: key);

  String currentID;

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  bool isLongPressed = false;

  double cardHeight = 90;

  @override
  Widget build(BuildContext context) {

    ForgeDates prevDate = LinkDateServices().getPrevDate(widget.currentID);
    Contact currentContact = AllContactsServices().getContactfromID(context, widget.currentID);

    //Get last connected date
    String lastConnected = prevDate.linkid != null
        ? 'Last connected on ${DateFormat('d MMM yyyy').format(prevDate.meetingDate!)} (${prevDate.meetingDate!.difference(DateTime.now()).inDays} days ago)'
        : 'No previous meetings available';

    return currentContact.displayName == ''
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Constants.contactDetailNavigate,
                  arguments: widget.currentID);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContactCircleAvatar(
                          currentContact: currentContact,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentContact.displayName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Constants.kBlackColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              lastConnected,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Constants.kSecondaryColor),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            WidgetTag(id: currentContact.id,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(),
                  NextConnectDateWidget(id: currentContact.id,),
                ],
              ),
            ),
          );
  }
}
