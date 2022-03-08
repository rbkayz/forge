import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';


class AllContactsPage extends StatelessWidget {
  const AllContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: AllContacts(),
    );
  }
}


class AllContacts extends StatefulWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    return (contacts == null || contacts.isEmpty)
        ? const Center(
            child: ForgeSpinKitRipple(
            size: 50,
            color: Constants.kPrimaryColor,
          ))
        : Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: ContactListBuilder(
              contacts: contacts,
            ));
  }
}

class ContactListBuilder extends StatefulWidget {
  ContactListBuilder({Key? key, required this.contacts}) : super(key: key);

  final List<Contact>? contacts;

  @override
  State<ContactListBuilder> createState() => _ContactListBuilderState();
}

class _ContactListBuilderState extends State<ContactListBuilder> {
  final linksBox = Hive.box(Constants.linksBox);

  String getInitials(List<String> nameParts) {
    try {
      if (nameParts.length > 1) {
        return nameParts[0].characters.first.toUpperCase() +
            nameParts[1].characters.first.toUpperCase();
      } else if (nameParts.length == 1) {
        return nameParts[0].characters.first.toUpperCase();
      } else {
        return '-';
      }
    } on Exception catch (e) {
      print(e.toString());
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.contacts!.length,
      itemBuilder: (context, index) {
        Contact currentContact = widget.contacts![index];
        Uint8List? currentContactImage = currentContact.photoOrThumbnail;
        String currentContactPhone = currentContact.phones.isNotEmpty
            ? currentContact.phones.first.number
            : '----------';
        List<String> nameParts = currentContact.displayName.split(" ");
        String initials = getInitials(nameParts);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Constants.contactDetailNavigate,
                    arguments: currentContact)
                .then((value) => setState(() {}));
          },
          child: ListTile(
            leading: (currentContactImage == null)
                ? CircleAvatar(
                    child: Text(initials),
                  )
                : CircleAvatar(
                    backgroundImage: MemoryImage(currentContactImage)),
            title: Text(currentContact.displayName),
            subtitle: Text(currentContactPhone),
            trailing: ToggleLinks(
              currentContact: currentContact,
            ),
          ),
        );
      },
    );
  }
}
