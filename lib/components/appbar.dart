import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/components/search.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';

class ForgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForgeAppBar({Key? key, this.title, this.showSearch = false, this.showOptions = false}) : super(key: key);

  final String? title;
  final bool showSearch;
  final bool showOptions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {

    final contacts = Provider.of<List<Contact>?>(context);

    return AppBar(
      title: (title == null) ? const AppBarForgeLogo() : AppBarTitle(title: title!),
      leadingWidth: (title == null) ? 56 : 45,
      actions: <Widget>[
        showSearch ? AppBarSearch(contacts: contacts) : const NullAction(),
        showOptions? const AppBarOptions() : const NullAction(),
      ],
    );
  }
}


///--------------------------------------------------------------
/// AppBar for contacts
///--------------------------------------------------------------


class ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  ContactAppBar({Key? key, this.isScrolled = false}) : super(key: key);

  bool isScrolled;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {

    Contact currentContact = Provider.of<Contact>(context);

    return AppBar(
      leading: const AppBarBackButton(),
      title: isScrolled ? AppBarTitle(title: currentContact.displayName) : const SizedBox.shrink(),
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


/* #############################################################################

Common widgets for the appbar

##############################################################################*/


class AppBarBackButton extends StatelessWidget {

  // BackButton (iOS style)

  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: Constants.kPrimaryColor,
      ),
      onPressed: () {
        Navigator.pop(context,true);
      },
    );
  }
}

class AppBarTitle extends StatelessWidget {

  // BackButton (Title)

  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}


class AppBarOptions extends StatelessWidget {

  // Options action button

  const AppBarOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.more_vert,
        ),
      ),
    );
  }
}

class AppBarAddLink extends StatelessWidget {

  // Options action button

  const AppBarAddLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          NavigatorKeys.homeKey.currentState!.pushNamed(Constants.allContactsNavigate);
        },
        child: const Icon(
          Icons.person_add_alt_outlined,
        ),
      ),
    );
  }
}


class AppBarSearch extends StatelessWidget {

  // Search action button

  const AppBarSearch({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  final List<Contact>? contacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: DataSearch(contacts: contacts));
        },
        child: const Icon(
          Icons.search,
        ),
      ),
    );
  }
}

class AppBarForgeLogo extends StatelessWidget {

  // Forge Logo

  const AppBarForgeLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Image.asset(Constants.forgeHeaderLogo, height: 60,),
    );
  }
}

class NullAction extends StatelessWidget {
  const NullAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.only(right: 0), child: SizedBox.shrink());
  }
}