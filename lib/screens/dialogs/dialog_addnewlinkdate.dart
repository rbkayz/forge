import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';

import '../../utilities/constants.dart';


class DialogAddNewLinkDate extends StatefulWidget {
  const DialogAddNewLinkDate({Key? key}) : super(key: key);

  @override
  State<DialogAddNewLinkDate> createState() => _DialogAddNewLinkDateState();
}

class _DialogAddNewLinkDateState extends State<DialogAddNewLinkDate> {


  final _newLinkFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _newLinkFormKey,
          child: Column(
            children: [

              Row(
                children: [

                  //WidgetAddLinkName(),



                  //Cancel Button
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            onPressed: () {

                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(primary: Constants.kPrimaryColor,backgroundColor: Constants.kWhiteColor)
                        ),
                      )
                  ),


                  //Done button
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            print('Done');
                            Navigator.pop(context);

                          },
                          child: const Text('Done'),
                          style: OutlinedButton.styleFrom(primary: Constants.kWhiteColor,backgroundColor: Constants.kPrimaryColor),
                        ),
                      ))
                ],
              )


            ],
          ),
        ),
      ),

      elevation: 20,

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),

      backgroundColor: Constants.kWhiteColor,
    );
  }
}


class WidgetAddLinkName extends StatefulWidget {
  const WidgetAddLinkName({Key? key}) : super(key: key);

  @override
  State<WidgetAddLinkName> createState() => _WidgetAddLinkNameState();
}

class _WidgetAddLinkNameState extends State<WidgetAddLinkName> {

  List<String> contactNames = [];
  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {

    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    contacts?.forEach((element) {contactNames.add(element.displayName); });

    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        } else {
          return contactNames;
        }
      },
      optionsViewBuilder:
          (context, Function(String) onSelected, options) {
        return Material(
          elevation: 4,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);

              return ListTile(
                // title: Text(option.toString()),
                title: Text(option.toString()),
                onTap: () {
                  onSelected(option.toString());
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: options.length,
          ),
        );
      },

      onSelected: (selectedString) {
        print(selectedString);
      },

      fieldViewBuilder:
          (context, controller, focusNode, onEditingComplete) {
        this.controller = controller;

        return Expanded(
          child: TextField(
            controller: controller,
            //focusNode: focusNode,
            //onEditingComplete: onEditingComplete,
            // decoration: InputDecoration(
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(8),
            //     borderSide: BorderSide(color: Colors.grey[300]!),
            //   ),
            //   focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(8),
            //     borderSide: BorderSide(color: Colors.grey[300]!),
            //   ),
            //   enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(8),
            //     borderSide: BorderSide(color: Colors.grey[300]!),
            //   ),
            //   hintText: "Enter a contact name",
            //   prefixIcon: Icon(Icons.person_outlined),
            // ),
          ),
        );
      },
    );
  }
}
