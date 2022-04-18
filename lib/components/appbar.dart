import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/components/search.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:provider/provider.dart';

import '../services/contacts_service.dart';

class ForgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForgeAppBar({Key? key, this.title, this.showSearch = false, this.showOptions = false, this.customWidget}) : super(key: key);

  final String? title;
  final bool showSearch;
  final bool showOptions;
  final Widget? customWidget;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {

    final contacts = Provider.of<List<Contact>?>(context);

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      title: (title == null) ? const AppBarForgeLogo() : AppBarTitle(title: title!),
      leading: (title == null) ? null : const AppBarBackButton(),
      leadingWidth: (title == null) ? 56 : 45,
      actions: <Widget>[
        customWidget != null ? customWidget! : const NullAction(),
        showSearch ? AppBarSearch(contacts: contacts) : const NullAction(),
        showOptions ? const AppBarOptions() : const NullAction(),
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

    String currentID = Provider.of<String>(context);
    Contact currentContact = AllContactsServices().getContactfromID(context, currentID);

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



///--------------------------------------------------------------
/// Common Widgets for the AppBar
///--------------------------------------------------------------


/// Sets the app bar back button (Cupertino style - <)
class AppBarBackButton extends StatelessWidget {

  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 20),
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


/// Sets the title text of the appbar
class AppBarTitle extends StatelessWidget {


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


/// Sets the more options (three dots) for the app bar
class AppBarOptions extends StatelessWidget {

  const AppBarOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      icon: Icon(Icons.more_vert),
      onPressed: () {
        print('dead code');
      },
    );
  }
}


/// Sets the add new link option for the app bar
class AppBarAddLink extends StatelessWidget {

  const AppBarAddLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      icon: Icon(Icons.person_add_alt_outlined),
      onPressed: () {
        NavigatorKeys.homeKey.currentState!.pushNamed(Constants.allContactsNavigate);
      },
    );
  }
}


/// Sets the search button in the app bar
class AppBarSearch extends StatelessWidget {

  const AppBarSearch({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  final List<Contact>? contacts;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(context: context, delegate: DataSearch(contacts: contacts));
      },
    );
  }
}


/// Sets the logo in the appbar (Defaults if there is no title text)
class AppBarForgeLogo extends StatelessWidget {

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

/// Sets the null action button in the appbar (if there is no icon)
class NullAction extends StatelessWidget {
  const NullAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.only(right: 0), child: SizedBox.shrink());
  }
}


