import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/services/auth.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:forge/services/links_service.dart';
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
  DialogAddNewLinkDate({Key? key, this.initDate}) : super(key: key);

  ForgeDates? initDate;

  @override
  State<DialogAddNewLinkDate> createState() => _DialogAddNewLinkDateState();
}

class _DialogAddNewLinkDateState extends State<DialogAddNewLinkDate> {


  final _newLinkFormKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  DateTime? newMeetingDate;


  // Inital values if date is provided
  String? currentName;
  DateTime? currentDate;
  String? currentType;


  @override
  Widget build(BuildContext context) {

    /// Initialize values if an initial forgedates is provided
    if (widget.initDate != null && widget.initDate?.linkid != null) {
      Contact initContact = AllContactsServices().getContactfromID(context, widget.initDate!.linkid!);
      currentName = initContact.displayName;
      currentDate = widget.initDate?.meetingDate;
      currentType = widget.initDate?.meetingType;

      newMeetingDate = widget.initDate?.meetingDate;
    }



    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
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

                  WidgetAddLinkName(NameController: NameController, currentName: currentName,),

                  SizedBox(height: 12,),

                  WidgetPickDateAlt(DateController: DateController, currentDate: currentDate, dateTimeCallBack: (DateTime date) {
                    newMeetingDate = date;
                  },),

                  SizedBox(height: 12,),

                  WidgetSetMeetingType(TypeController: TypeController, currentType: currentType, annual: widget.initDate?.annual,),

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

                            /// Executes the addition or modification of the new date once done
                            onPressed: () {

                              if(_newLinkFormKey.currentState!.validate()) {
                                
                                Box linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));
                                List<Contact>? contacts = Provider.of<List<Contact>?>(context, listen: false);

                                String currentDisplayName = NameController.text;

                                if (contacts != null) {

                                  Contact currentContact = contacts.where((element) => element.displayName == currentDisplayName).first;

                                  ForgeLinks? currentLink = linksBox.get(currentContact.id);

                                  // Makes currentLink nullable, and then creates a link if it is null;
                                  if (currentLink == null) {
                                    LinkDateServices.activateLink(context, currentContact.id);
                                    currentLink = linksBox.get(currentContact.id);
                                  } else {
                                    currentLink.isActive = true;
                                  }

                                  String newMeetingType = TypeController.text;

                                  // If initial date is null, then adds a new date
                                  if (widget.initDate == null) {

                                    ForgeDates newDate = ForgeDates(
                                        meetingDate: newMeetingDate, meetingType: newMeetingType, linkid: currentContact.id, isComplete: false);

                                    HapticFeedback.lightImpact();
                                    currentLink!.linkDates.add(newDate);

                                  } else {

                                    if (currentLink != null) {

                                      // checks if the initdate exists in the link. If it does, then updates it
                                      if (currentLink.linkDates.contains(widget.initDate)) {
                                        currentLink.linkDates
                                            .where((element) => element == widget.initDate)
                                            .first
                                            .meetingDate = newMeetingDate;
                                        currentLink.linkDates
                                            .where((element) => element == widget.initDate)
                                            .first
                                            .meetingType = newMeetingType;
                                      }

                                      // If initdate exists, then creates a new ForgeDate, and then adds it. Typically used for contact screen
                                      else {

                                        ForgeDates newDate = ForgeDates(
                                            meetingDate: newMeetingDate, meetingType: newMeetingType, linkid: widget.initDate!.linkid, isComplete: widget.initDate!.isComplete, annual: widget.initDate!.annual);

                                        currentLink.linkDates.add(newDate);

                                      }
                                    }
                                  }
                                  
                                  
                                  linksBox.put(currentLink!.id, currentLink);

                                  HapticFeedback.lightImpact();
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
  WidgetAddLinkName({Key? key, required this.NameController, this.currentName}) : super(key: key);

  TextEditingController NameController;
  String? currentName;

  @override
  State<WidgetAddLinkName> createState() => _WidgetAddLinkNameState();
}

class _WidgetAddLinkNameState extends State<WidgetAddLinkName> {

  List<String> contactNames = [];


  @override
  Widget build(BuildContext context) {

    List<Contact>? contacts = Provider.of<List<Contact>?>(context);
    widget.NameController.text = widget.currentName ?? '';

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
            readOnly: widget.currentName != null ? true : false,
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
  WidgetPickDateAlt({Key? key, required this.DateController, required this.dateTimeCallBack, this.currentDate}) : super(key: key);

  TextEditingController DateController;
  final DateTimeCallBack dateTimeCallBack;
  DateTime? currentDate;

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

    date = widget.currentDate;
    widget.DateController.text = (date != null) ? DateFormat('d MMM y').format(date!) : '';

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
  WidgetSetMeetingType({Key? key, required this.TypeController, this.currentType, this.annual}) : super(key: key);

  TextEditingController TypeController;
  String? currentType;
  bool? annual;

  @override
  State<WidgetSetMeetingType> createState() => _WidgetSetMeetingTypeState();
}

class _WidgetSetMeetingTypeState extends State<WidgetSetMeetingType> {



  @override
  Widget build(BuildContext context) {

    widget.TypeController.text = widget.currentType ?? '';

    return TextFormField(
      controller: widget.TypeController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.annual == true ? 'Birthday / Anniversary' : 'Meeting description',
        prefixIcon: Icon(Icons.note_add_outlined),
      ),

    );
  }
}
