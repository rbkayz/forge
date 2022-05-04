import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../models/links_model.dart';
import '../../../services/auth.dart';
import '../../../services/contacts_service.dart';
import '../../dialogs/dialog_addnewlinkdate.dart';

class ContactInfoTab extends StatefulWidget {
  ContactInfoTab({Key? key}) : super(key: key);

  @override
  State<ContactInfoTab> createState() => _ContactInfoTabState();
}

class _ContactInfoTabState extends State<ContactInfoTab> {

  Contact? currentContact;

  launchDialer(String currPhone) async {
    String url = 'tel:$currPhone';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchWhatsapp(String currPhone) async {
    String url = 'whatsapp://send?phone=$currPhone';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchSMS(String currPhone) async {
    String url = 'sms:$currPhone';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  launchEmail(String currEmail) async {

    String url = 'mailto:${currEmail}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }

  }


  @override
  Widget build(BuildContext context) {

    String currentID = Provider.of<String>(context);
    
    currentContact = (currentContact == null) ? AllContactsServices().getContactfromID(context, currentID) : currentContact;
    ForgeLinks? currentLink = LinkDateServices.getLinkfromid(currentID, context);

    return SingleChildScrollView(
      child: Column(
          children: [

            ///--------------------------------------------------------------
            /// PHONES
            ///--------------------------------------------------------------

            InfoDivider(divText: 'CONTACT',
            editAddButton: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              splashRadius: 16,
              iconSize: 16,
              icon: const Icon(Icons.edit,color: Constants.kSecondaryColor,),
              onPressed: () async {

                HapticFeedback.lightImpact();
                currentContact = await FlutterContacts.openExternalEdit(currentID);

                setState(() {

                });

              },
            ),
            ),

            currentContact!.phones.isEmpty ? SizedBox.shrink() : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: currentContact!.phones.isNotEmpty
                    ? currentContact!.phones.length
                    : 1,
                itemBuilder: (context, index) {
                  String currentContactPhone = currentContact!.phones[index].number;
                  String? currentContactLabel = Constants
                      .phoneLabelToString[currentContact!.phones[index].label];
                  return CustomListTile(
                    subTitle: (currentContactLabel ?? 'Mobile').toUpperCase(),
                    mainTitle: currentContactPhone,
                    leadingIcon: const Icon(Icons.phone),
                    trailingIcon1: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Color.fromRGBO(37, 211, 102, 1),
                    ),
                    trailingIcon2: const Icon(Icons.message),
                    onPressedMain: () {
                      launchDialer(currentContactPhone);
                    },
                    onPressedTrail1: () {
                      launchWhatsapp(currentContactPhone);
                    },
                    onPressedTrail2: () {
                      launchSMS(currentContactPhone);
                    },
                  );
                },
            ),

            ///--------------------------------------------------------------
            /// EMAIL
            ///--------------------------------------------------------------

            currentContact!.emails.isEmpty ? SizedBox.shrink() : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentContact!.emails.isNotEmpty
                  ? currentContact!.emails.length
                  : 1,
              itemBuilder: (context, index) {
                String currentContactEmail = currentContact!.emails[index].address;
                String? currentContactLabel = Constants.emailLabelToString[currentContact!.emails[index].label];
                return CustomListTile(
                  subTitle: (currentContactLabel ?? 'Personal').toUpperCase(),
                  mainTitle: currentContactEmail.toLowerCase(),
                  leadingIcon: const Icon(Icons.email_outlined),
                  trailingIcon1: null,
                  trailingIcon2: null,
                  onPressedMain: () {
                    launchEmail(currentContactEmail.toLowerCase());
                  },
                  onPressedTrail1: () {},
                  onPressedTrail2: () {},
                );
              },
            ),

            ///--------------------------------------------------------------
            /// Key Dates
            ///--------------------------------------------------------------

            InfoDivider(divText: 'DATES',
              editAddButton: IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                splashRadius: 16,
                iconSize: 16,
                icon: const Icon(Icons.add_alert_outlined,color: Constants.kSecondaryColor,),
                onPressed: () {

                  HapticFeedback.lightImpact();
                  if(currentLink == null) {
                    LinkDateServices.activateLink(context, currentID);
                  }

                  showDialog(useRootNavigator: false, context: context, builder: (context) => DialogAddNewLinkDate(initDate: ForgeDates(linkid: currentID, isComplete: false, annual: true)));


                },
              ),
            ),


            currentLink?.linkDates.where((element) => element.annual == true) == null ? SizedBox.shrink() :
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentLink?.linkDates.where((element) => element.annual == true).length,
              itemBuilder: (context, index) {

                ForgeDates? currentDate = currentLink?.linkDates.where((element) => element.annual == true).elementAt(index);

                return CustomListTile(
                  subTitle: (currentDate?.meetingType ?? '-').toUpperCase(),
                  mainTitle: currentDate?.meetingDate != null ? DateFormat('d MMM').format(currentDate!.meetingDate!) : '-',
                  leadingIcon: const Icon(Icons.cake_outlined),
                  trailingIcon1: Icon(Icons.edit, color: Constants.kSecondaryColor,),
                  trailingIcon2: Icon(Icons.delete, color: Constants.kSecondaryColor,),
                  onPressedMain: () {
                  },
                  onPressedTrail1: () {


                    //TODO To fix birthday
                    showDialog(useRootNavigator: false, context: context, builder: (context) => DialogAddNewLinkDate(initDate: currentDate));

                  },
                  onPressedTrail2: () {

                    if (currentLink != null ) {
                      currentLink.linkDates.removeWhere((element) => element == currentDate);
                      Box linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));
                      linksBox.put(currentLink.id, currentLink);
                    }


                  },
                );
              },
            ),



          ],
      ),
    );
  }
}

///--------------------------------------------------------------
/// Custom List Tile
///--------------------------------------------------------------

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.mainTitle,
    required this.subTitle,
    required this.leadingIcon,
    required this.trailingIcon1,
    this.trailingIcon2,
    required this.onPressedMain,
    this.onPressedTrail1,
    this.onPressedTrail2,
  }) : super(key: key);

  final String mainTitle;
  final String subTitle;
  final Icon leadingIcon;
  final Icon? trailingIcon1;
  final Icon? trailingIcon2;
  final VoidCallback onPressedMain;
  final VoidCallback? onPressedTrail1;
  final VoidCallback? onPressedTrail2;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[leadingIcon],
      ),
      title: Text(mainTitle),
      subtitle: Text(subTitle),
      trailing: (trailingIcon1 == null && trailingIcon2 == null) ? null : Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: trailingIcon1 ?? const Icon(null),
                onPressed: onPressedTrail1),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              icon: trailingIcon2 ?? const Icon(null),
              onPressed: onPressedTrail2,
            ),
          ]),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
      minLeadingWidth: 30,
      onTap: onPressedMain,
    );
  }
}

///--------------------------------------------------------------
/// Custom Divider
///--------------------------------------------------------------

class InfoDivider extends StatelessWidget {
  InfoDivider({Key? key, required this.divText, this.editAddButton}) : super(key: key);

  final String divText;
  final Widget? editAddButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            divText,
            style: const TextStyle(
              color: Constants.kSecondaryColor,
              fontSize: 14,
            ),
          ),
          Expanded(child: Divider(
            indent: 10,
            color: Colors.grey.shade200,
          )),

          editAddButton ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}
