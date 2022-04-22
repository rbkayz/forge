import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';

import '../../models/links_model.dart';
import '../../utilities/constants.dart';


///--------------------------------------------------------------
/// Dialog Box to add or modify a link date
///--------------------------------------------------------------

class DialogAddNewLinkDate extends StatefulWidget {
  const DialogAddNewLinkDate({Key? key}) : super(key: key);

  @override
  State<DialogAddNewLinkDate> createState() => _DialogAddNewLinkDateState();
}

class _DialogAddNewLinkDateState extends State<DialogAddNewLinkDate> {


  final _newLinkFormKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  late DateTime newMeetingDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Dialog(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _newLinkFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Center(
                    child: Text(
                      'ADD / EDIT MEETING',
                      style: TextStyle(
                          fontSize: 18,
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ),

                  SizedBox(height: 12,),

                  WidgetAddLinkName(NameController: NameController,),

                  SizedBox(height: 12,),

                  WidgetPickDateAlt(DateController: DateController, dateTimeCallBack: (DateTime date) {
                    newMeetingDate = date;
                    print('hello');
                  },),

                  SizedBox(height: 12,),

                  WidgetSetMeetingType(TypeController: TypeController,),

                  SizedBox(height: 12,),

                  Row(
                    children: [

                      //Cancel Button
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(primary: Constants.kPrimaryColor,backgroundColor: Constants.kWhiteColor)
                          )
                      ),

                      const SizedBox(width: 16,),


                      //Done button
                      Expanded(
                          child: OutlinedButton(
                            onPressed: () {

                              if(_newLinkFormKey.currentState!.validate()) {
                                
                                Box linksBox = Hive.box(Constants.linksBox);
                                List<Contact>? contacts = Provider.of<List<Contact>?>(context, listen: false);

                                String currentDisplayName = NameController.text;

                                if (contacts != null) {

                                  Contact currentContact = contacts.where((element) => element.displayName == currentDisplayName).first;

                                  ForgeLinks currentLink = linksBox.get(currentContact.id);

                                  //TODO: Need to make currentLink nullable, and then create a link if it is null;

                                  String newMeetingType = TypeController.text;

                                  ForgeDates newDate = ForgeDates(meetingDate: newMeetingDate, meetingType: newMeetingType, linkid: currentContact.id, isComplete: false);

                                  currentLink.linkDates.add(newDate);

                                  linksBox.put(currentLink.id, currentLink);

                                  Navigator.pop(context);

                                }

                              }

                            },
                            child: const Text('Done'),
                            style: OutlinedButton.styleFrom(primary: Constants.kWhiteColor,backgroundColor: Constants.kPrimaryColor),
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
        ),
      ),
    );
  }
}


///--------------------------------------------------------------
/// Autocomplete widget builder to fill in the name
///--------------------------------------------------------------


class WidgetAddLinkName extends StatefulWidget {
  WidgetAddLinkName({Key? key, required this.NameController}) : super(key: key);

  TextEditingController NameController;

  @override
  State<WidgetAddLinkName> createState() => _WidgetAddLinkNameState();
}

class _WidgetAddLinkNameState extends State<WidgetAddLinkName> {

  List<String> contactNames = [];


  @override
  Widget build(BuildContext context) {

    List<Contact>? contacts = Provider.of<List<Contact>?>(context);

    /// Convert contacts to list of contact names
    contacts?.forEach((element) {
      contactNames.add(element.displayName);
    });


    /// Validator function
    String? NameValidator(text) {

      if (text == null || text.isEmpty) {
        return 'Name cannot be blank';
      }

      if (contactNames.contains(text) == false) {
        return 'Name is invalid';
      }
      return null;

    }


    /// Auto-complete function to be added here
    return RawAutocomplete(
      textEditingController: widget.NameController,
        focusNode: FocusNode(),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          } else {

            return contactNames.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));

          }
        },



      optionsViewBuilder: (context, Function(String) onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: MediaQuery.of(context).size.width*0.65),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);

                    return ListTile(
                      visualDensity: VisualDensity(vertical: -3),
                      title: Text(option.toString(), overflow: TextOverflow.ellipsis,),
                      onTap: () {
                        onSelected(option.toString());
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: options.length,
                ),
              ),
              ),
          );
      },

      onSelected: (String value) {
          widget.NameController.text = value;
      },

        fieldViewBuilder:
            (context, controller, focusNode, onEditingComplete) {
          widget.NameController = controller;

          return TextFormField(
            controller: controller,
            validator: NameValidator,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "Enter a contact name",
              prefixIcon: Icon(Icons.person_outlined),
            ),
          );
        },
    );
  }
}


///--------------------------------------------------------------
/// Widget Pick a date
///--------------------------------------------------------------

typedef void DateTimeCallBack (DateTime date);

class WidgetPickDateAlt extends StatefulWidget {
  WidgetPickDateAlt({Key? key, required this.DateController, required this.dateTimeCallBack}) : super(key: key);

  TextEditingController DateController;
  final DateTimeCallBack dateTimeCallBack;

  @override
  State<WidgetPickDateAlt> createState() => _WidgetPickDateAltState();
}

class _WidgetPickDateAltState extends State<WidgetPickDateAlt> {

  DateTime? date;

  /// Validator function
  String? DateValidator(text) {

    if (text == null || text.isEmpty) {
      return 'Date cannot be blank';
    }

    return null;

  }




  @override
  Widget build(BuildContext context) {

    widget.DateController.text = date?.toString() ?? '';

    return TextFormField(
      controller: widget.DateController,
      validator: DateValidator,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: "Set a date",
        prefixIcon: Icon(Icons.calendar_today_rounded),
      ),
      onTap: () async {

        date = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: Constants().minDate,
            lastDate: Constants().maxDate
        );

        if (date != null ) {
          widget.DateController.text = DateFormat('d MMM y').format(date!);
          widget.dateTimeCallBack(date!);
        }

      },
    );
  }
}




///--------------------------------------------------------------
/// Widget Pick a date
///--------------------------------------------------------------


class WidgetSetMeetingType extends StatefulWidget {
  WidgetSetMeetingType({Key? key, required this.TypeController}) : super(key: key);

  TextEditingController TypeController;

  @override
  State<WidgetSetMeetingType> createState() => _WidgetSetMeetingTypeState();
}

class _WidgetSetMeetingTypeState extends State<WidgetSetMeetingType> {



  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: widget.TypeController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: "Meeting description",
        prefixIcon: Icon(Icons.note_add_outlined),
      ),

    );
  }
}
