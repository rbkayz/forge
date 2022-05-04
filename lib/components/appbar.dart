import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/components/search.dart';
import 'package:forge/components/toggle_links.dart';
import 'package:forge/models/links_model.dart';
import 'package:forge/screens/dialogs/dialog_addnewlinkdate.dart';
import 'package:forge/screens/dialogs/dialog_popupmenu.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/services/router.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../screens/dialogs/dialog_setrecurringmeeting.dart';
import '../services/auth.dart';
import '../services/contacts_service.dart';

class ForgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForgeAppBar({Key? key, this.title, this.showSearch = false, this.showOptions = false, this.customWidget1, this.customWidget2}) : super(key: key);

  final String? title;
  final bool showSearch;
  final bool showOptions;
  final Widget? customWidget1;
  final Widget? customWidget2;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {

    final contacts = Provider.of<List<Contact>?>(context);

    return AppBar(
      //systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: Constants.kWhiteColor),
      title: (title == null) ? const AppBarForgeLogo() : AppBarTitle(title: title!),
      leading: (title == null) ? null : const AppBarBackButton(),
      leadingWidth: (title == null) ? 56 : 45,
      actions: <Widget>[
        customWidget2 != null ? customWidget2! : const NullAction(),
        customWidget1 != null ? customWidget1! : const NullAction(),
        showSearch ? AppBarSearch(contacts: contacts) : const NullAction(),
        showOptions ? const TimelinePopupMenu() : const NullAction(),
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
    ForgeLinks? currentLink = LinkDateServices.getLinkfromid(currentID, context);

    return AppBar(
      leading: const AppBarBackButton(),
      title: isScrolled ? AppBarTitle(title: currentContact.displayName) : const SizedBox.shrink(),
      backgroundColor: Colors.white,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      actions: <Widget>[


        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 10),
          visualDensity: VisualDensity.compact,
          splashRadius: 20,
          icon: Icon(Icons.repeat, color: (currentLink?.recurringEnabled ?? false) ? Constants.kPrimaryColor : Constants.kSecondaryColor,),
          onPressed: () {
            HapticFeedback.lightImpact();
            showDialog(useRootNavigator: false, context: context, builder: (context) => DialogSetRecurring(currentID: currentID,));
          },
        ),



        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 10),
          visualDensity: VisualDensity.compact,
          splashRadius: 20,
          icon: Icon(Icons.add_task_outlined, color: (currentLink?.isActive ?? false) ? Constants.kPrimaryColor : Constants.kSecondaryColor),
          onPressed: () {
            HapticFeedback.lightImpact();
            showDialog(useRootNavigator: false, context: context, builder: (context) => DialogAddNewLinkDate(initDate: ForgeDates(linkid: currentContact.id, isComplete: false),));
            },
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(10,0,20,0),
          child: ToggleLinks(currentContact: currentContact),
        ),


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
        HapticFeedback.lightImpact();
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
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}


// /// Sets the datepicker
// class AppBarOptions extends StatelessWidget {
//
//   const AppBarOptions({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//         itemBuilder: (context) =>
//             [
//         PopupMenuEntry() DatePickerDialog(initialDate: Datetime.now(), firstDate: Datetime.now(), lastDate: Datetime.now()),
//             ]
//     );
//
//   }
// }


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
        HapticFeedback.lightImpact();
        NavigatorKeys.homeKey.currentState!.pushNamed(Constants.allContactsNavigate);
      },
    );
  }
}


/// Sets the add new link date option for the app bar
class AppBarAddDate extends StatelessWidget {

  AppBarAddDate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      icon: Icon(Icons.add_task_outlined),
      onPressed: () {
        HapticFeedback.lightImpact();
        showDialog(useRootNavigator: false, context: context, builder: (context) => DialogAddNewLinkDate());
      },
    );
  }
}


/// Sets the add new link date option for the app bar
class AppBarScrolltoToday extends StatelessWidget {

  AppBarScrolltoToday({
    Key? key, required this.itemController
  }) : super(key: key);

  final ItemScrollController itemController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      icon: Icon(Icons.calendar_today),
      onPressed: () {

        HapticFeedback.lightImpact();

        Box linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));
        Box prefsBox = Hive.box(FirebaseAuthService.getPrefsBox(context));

        List<ForgeDates> dates = LinkDateServices.sortAllDates(linksBox.values, showAllDate: prefsBox.get(Constants.showAllDatesinTimeline, defaultValue: true));

        List<ForgeDates> nextDateList = dates
            .where((element) =>
            element.meetingDate!
                .compareTo(DateUtils.dateOnly(DateTime.now())) >=
                0)
            .toList();

        nextDateList.isNotEmpty
            ? nextDateList
            .sort((a, b) => a.meetingDate!.compareTo(b.meetingDate!))
            : null;

        ForgeDates nextDate =
        nextDateList.isNotEmpty ? nextDateList.first : ForgeDates();

        int indexval = dates.indexWhere((element) => element == nextDate);

        itemController.scrollTo(index: indexval+1, duration: Duration(milliseconds: 500),alignment: 0.05);

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
        HapticFeedback.lightImpact();
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


