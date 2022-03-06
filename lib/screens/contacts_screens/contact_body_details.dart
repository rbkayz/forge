import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forge/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class ContactDetailsTab extends StatelessWidget {
  ContactDetailsTab({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;
  final relationshipsBox = Hive.box(Constants.linksBox);

  launchDialer (String currPhone) async {

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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: currentContact.phones.isNotEmpty ? currentContact.phones.length : 1,
      itemBuilder: (context, index) {
        String currentContactPhone = currentContact.phones[index].number;
        String? currentContactLabel = Constants.phoneLabelToString[currentContact.phones[index].label];
          return CustomListTile(
            subTitle: (currentContactLabel ?? 'Mobile').toUpperCase(),
            mainTitle: currentContactPhone,
            leadingIcon: const Icon(Icons.phone),
            trailingIcon1: const Icon(FontAwesomeIcons.whatsapp,color: Color.fromRGBO(37, 211, 102,1) ,),
            trailingIcon2: const Icon(Icons.message),
            onPressedMain: () {launchDialer(currentContactPhone);},
            onPressedTrail1: () {launchWhatsapp(currentContactPhone);},
            onPressedTrail2: () {launchSMS(currentContactPhone);},
        );
      },
    );
  }

}


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
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[leadingIcon],
      ),
      title: Text(mainTitle),
      subtitle: Text(subTitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(icon: trailingIcon1 ?? const Icon (null), onPressed: onPressedTrail1),
            const SizedBox(width: 15,),
            IconButton(icon: trailingIcon2 ?? const Icon(null), onPressed: onPressedTrail2,),
          ]
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
      minLeadingWidth: 30,
      onTap: onPressedMain,
    );
  }
}


