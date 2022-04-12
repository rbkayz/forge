import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class ContactInfoTab extends StatelessWidget {
  ContactInfoTab({Key? key}) : super(key: key);


  final relationshipsBox = Hive.box(Constants.linksBox);

  launchDialer(String currPhone) async {
    String url = 'tel:$currPhone';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchWhatsapp(String currPhone) async {
    String url = 'whatsapp://send?phone=$currPhone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchSMS(String currPhone) async {
    String url = 'sms:$currPhone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    Contact currentContact = Provider.of<Contact>(context);

    return SingleChildScrollView(
      child: Column(
          children: [

            ///--------------------------------------------------------------
            /// PHONES
            ///--------------------------------------------------------------

            const InfoDivider(divText: 'CONTACT'),

            currentContact.phones.isEmpty ? SizedBox.shrink() : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: currentContact.phones.isNotEmpty
                    ? currentContact.phones.length
                    : 1,
                itemBuilder: (context, index) {
                  String currentContactPhone = currentContact.phones[index].number;
                  String? currentContactLabel = Constants
                      .phoneLabelToString[currentContact.phones[index].label];
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

            currentContact.emails.isEmpty ? SizedBox.shrink() : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentContact.emails.isNotEmpty
                  ? currentContact.emails.length
                  : 1,
              itemBuilder: (context, index) {
                String currentContactEmail = currentContact.emails[index].address;
                String? currentContactLabel = Constants.emailLabelToString[currentContact.emails[index].label];
                return CustomListTile(
                  subTitle: (currentContactLabel ?? 'Personal').toUpperCase(),
                  mainTitle: currentContactEmail.toLowerCase(),
                  leadingIcon: const Icon(Icons.email_outlined),
                  trailingIcon1: null,
                  trailingIcon2: null,
                  onPressedMain: () {

                  },
                  onPressedTrail1: () {

                  },
                  onPressedTrail2: () {

                  },
                );
              },
            ),

            ///--------------------------------------------------------------
            /// Key Dates
            ///--------------------------------------------------------------

            const InfoDivider(divText: 'DATES'),



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
  const InfoDivider({Key? key, required this.divText}) : super(key: key);

  final String divText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 25, 0),
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
          ))
        ],
      ),
    );
  }
}
