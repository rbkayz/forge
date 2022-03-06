import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:forge/screens/contacts_screens/all_contacts.dart';
import 'package:forge/utilities/constants.dart';

class DataSearch extends SearchDelegate<String> {
  
  final List<Contact>? contacts;
  
  DataSearch({required this.contacts});
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
            color: Constants.kPrimaryColor, fontWeight: FontWeight.w400),
        border: InputBorder.none,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Center(
        child: Text(
      'In Progress',
      style: TextStyle(
        color: Constants.kSecondaryColor,
        fontSize: 20,
      ),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final filteredcontacts = contacts == null ? contacts : contacts!.where((element) => element.displayName.toLowerCase().contains(query.toLowerCase())).toList();
    return query.isEmpty ?
    const Center(child:Text('Enter a string')) : ContactListBuilder(contacts: filteredcontacts);
  }
}