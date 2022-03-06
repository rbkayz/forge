import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/components/search.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';

class ForgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForgeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {

    final contacts = Provider.of<List<Contact>?>(context);

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
        child: Image.asset(Constants.forgeHeaderLogo, height: 60,),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: DataSearch(contacts: contacts));
            },
            child: const Icon(
              Icons.search,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.more_vert,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Constants.kPrimaryColor,
        ), 
        onPressed: () {
          Navigator.pop(context,true);
        },
      ),
      title: Text(
        currentContact.displayName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ToggleLinks(currentContact: currentContact),
        )
      ],
    );
  }
}