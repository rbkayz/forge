import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/components/appbar.dart';
import 'package:forge/components/loader.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';
import '../widgets_links.dart';

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
        : Scaffold(
            appBar: const ForgeAppBar(title: 'Add / remove links', showSearch: true,),
            body: ContactListBuilder(
              contacts: contacts,
            ),
          );
  }
}

class ContactListBuilder extends StatefulWidget {
  ContactListBuilder({Key? key, required this.contacts}) : super(key: key);

  final List<Contact>? contacts;

  @override
  State<ContactListBuilder> createState() => _ContactListBuilderState();
}

class _ContactListBuilderState extends State<ContactListBuilder> {



  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.contacts!.length,
      itemBuilder: (context, index) {
        Contact currentContact = widget.contacts![index];
        String currentContactPhone = currentContact.phones.isNotEmpty
            ? currentContact.phones.first.number
            : '----------';

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Constants.contactDetailNavigate,
                    arguments: currentContact.id).then((value) => setState(() {}));
          },
          child: ListTile(
            leading: ContactCircleAvatar(currentContact: currentContact,),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
