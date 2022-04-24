import 'package:flutter/material.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import '../../models/links_model.dart';
import '../../utilities/constants.dart';


///--------------------------------------------------------------
/// Dialog Box to add or modify a link date
///--------------------------------------------------------------

class DialogSetRecurring extends StatefulWidget {
  DialogSetRecurring({Key? key, required this.currentID}) : super(key: key);

  String currentID;

  @override
  State<DialogSetRecurring> createState() => _DialogSetRecurringState();
}

class _DialogSetRecurringState extends State<DialogSetRecurring> {


  final _newRecurringFormKey = GlobalKey<FormState>();
  int? dropdownvalueNum;
  String? dropdownvalueType;
  bool switchVal = false;

  List<int> listRecurringNum = [
    1,2,3,4,5,6,7,8,9,10,11,12
  ];

  List<String> listRecurringType = [
    'Week(s)', 'Month(s)'
  ];


  @override
  void initState() {

    ForgeLinks currentLink = LinkDateServices().getLinkfromid(widget.currentID) ?? ForgeLinks(id: widget.currentID);

    if (currentLink.recurringNum != null && currentLink.recurringType != null) {
      dropdownvalueNum = currentLink.recurringNum;
      dropdownvalueType = currentLink.recurringType;
      switchVal = currentLink.recurringEnabled ?? false;
    }

  }

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Dialog(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _newRecurringFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Center(
                    child: Text(
                      'SET RECURRING FREQUENCY',
                      style: TextStyle(
                          fontSize: 18,
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ),

                  SizedBox(height: 12,),


                  const Center(
                      child: Text('When you mark a meeting as complete, this automatically creates a new reminder',
                      style: TextStyle(color: Constants.kSecondaryColor, fontSize: 14, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)),


                  SizedBox(height: 12,),


                  Center(
                    child: SwitchListTile(
                        value: switchVal,
                        activeColor: Constants.kPrimaryColor,
                        title: Text('Enable recurring meetings', style: TextStyle(color: Constants.kSecondaryColor, fontSize: 14,),),
                        onChanged: (newVal) {
                          setState(() {
                            switchVal = newVal;
                          });
                    }),
                  ),


                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      DropdownButton(

                        // Initial Value
                        value: dropdownvalueNum,
                        hint: Text('#', style: const TextStyle(color: Constants.kSecondaryColor, fontSize: 14),),
                        alignment: Alignment.center,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: listRecurringNum.map((int item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.toString()),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (int? newValue) {
                          setState(() {
                            dropdownvalueNum = newValue!;
                          });
                        },
                      ),

                      const SizedBox(width: 30,),

                      DropdownButton(

                        // Initial Value
                        value: dropdownvalueType,
                        hint: Text('Weeks / Months', style: TextStyle(color: Constants.kSecondaryColor, fontSize: 14),),
                        alignment: Alignment.center,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: listRecurringType.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.toString().toUpperCase()),
                          );
                        }).toList(),

                        // After selecting the desired option,it will
                        // change button value to selected value

                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueType = newValue!;
                          });
                        },
                      ),

                    ],
                  ),

                  SizedBox(height: 12,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [

                        /// Cancel button
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


                        /// Done button
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {

                                  ForgeLinks currentLink = LinkDateServices().getLinkfromid(widget.currentID) ?? ForgeLinks(id: widget.currentID);

                                  currentLink.recurringEnabled = switchVal;
                                  currentLink.recurringNum = dropdownvalueNum;
                                  currentLink.recurringType = dropdownvalueType;

                                  Box linksBox = Hive.box(Constants.linksBox);

                                  linksBox.put(currentLink.id, currentLink);

                                  Navigator.pop(context);
                                },
                                child: const Text('Done'),
                                style: OutlinedButton.styleFrom(primary: Constants.kWhiteColor,backgroundColor: Constants.kPrimaryColor)
                            )
                        ),

                      ],
                    ),
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