import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/utilities/constants.dart';

class ContactDetailsTab extends StatelessWidget {
  const ContactDetailsTab({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

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
            trailingIcon: const Icon(Icons.message),
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
    required this.trailingIcon,
  }) : super(key: key);

  final String mainTitle;
  final String subTitle;
  final Icon leadingIcon;
  final Icon trailingIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[leadingIcon],
      ),
      title: Text(mainTitle),
      subtitle: Text(subTitle),
      trailing: trailingIcon,
    );
  }
}


