import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/screens/tab_links/widgets_links.dart';
import 'package:forge/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../services/contacts_service.dart';
import '../../services/links_service.dart';
import '../../services/listenables.dart';
import '../../utilities/constants.dart';

class LinksPage extends StatefulWidget {
  const LinksPage({Key? key}) : super(key: key);

  @override
  _LinksPageState createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  final linksBox = Hive.box(Constants.linksBox);
  final prefsBox = Hive.box(Constants.prefsBox);
  final contactsService = AllContactsServices();
  final linksService = LinkDateServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder2(
        first: linksBox.listenable(),
        second: prefsBox.listenable(),
        builder: (BuildContext context, Box links, Box prefs, Widget? child) {

          String sortLinkMethod = prefs.get(Constants.sortLinkMethod, defaultValue: Constants.sortbyDate);
          List<ForgeLinks> sortedlinksValues = links.toMap().values.cast<ForgeLinks>().where((element) => element.isActive).toList();

          sortedlinksValues.sort((a, b) => contactsService.getContactfromID(context, a.id).displayName.compareTo(contactsService.getContactfromID(context, b.id).displayName));

          switch(sortLinkMethod) {

            case Constants.sortbyDate:
              {
                sortedlinksValues.sort((a, b) {

                  DateTime meetingDate1 = linksService.getNextDate(a.id).meetingDate ?? DateTime.now().add(Duration(days: 5000));
                  DateTime meetingDate2 = linksService.getNextDate(b.id).meetingDate ?? DateTime.now().add(Duration(days: 5000));

                  return meetingDate1.compareTo(meetingDate2);

                });
              } break;

        }


          return LinkListView(linksValues: sortedlinksValues);
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

  @override
  Widget build(BuildContext context) {

    /// Retrieves the list of contacts from the provider
    List<Contact>? contacts = Provider.of<List<Contact>?>(context);


    return (contacts == null || contacts.isEmpty)

          /// Returns a loading screen if contacts is empty
        ? const Center(
            child: ForgeSpinKitRipple(
            size: 100,
            color: Constants.kPrimaryColor,
          ))

          /// Listview that builds a list of cards separated with a grey divider
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

              /// Retrieves a contact. Returns an empty contact if contacts is empty
              Contact? currentContact = (contacts.isEmpty)
                  ? Contact()
                  : contacts
                      .where((element) => element.id == currentLink.id)
                      .single;

              /// Returns a linkcard is link is active, else an empty box
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

    return currentContact.id == ''

          /// Returns an empty box if contact id is blank
        ? const SizedBox.shrink()

          /// Calls a Gesture detector on Tap
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, Constants.contactDetailNavigate,
                  arguments: widget.currentID);
            },

            child: Padding(

              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
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

                  NextConnectDateWidget(id: currentContact.id,),
                ],
              ),
            ),
          );
  }
}
