import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import '../../models/links_model.dart';
import '../../utilities/constants.dart';
import '../dialogs/dialog_addnewlinkdate.dart';
import 'package:intl/intl.dart';


///--------------------------------------------------------------
/// Link Date Tile (single row for each date)
///--------------------------------------------------------------

class LinkDateTile extends StatefulWidget {
  LinkDateTile({Key? key, required this.date}) : super(key: key);

  final ForgeDates date;

  @override
  State<LinkDateTile> createState() => _LinkDateTileState();
}

class _LinkDateTileState extends State<LinkDateTile> {

  @override
  Widget build(BuildContext context) {

    /// Receives the current contact from the ID in the date. If null, then returns an empty contact
    final currentContact =
        AllContactsServices().getContactfromID(context, widget.date.linkid!);


    return currentContact.displayName == ''
          /// returns an empty box if contact name is null
        ? const SizedBox.shrink()

          /// Navigates to the detail sheet on tap
        : GestureDetector(

            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, Constants.contactDetailNavigate,
                  arguments: currentContact.id);
            },


            child: Container(

              // 18 px padding on Left to align with Forge
              padding: const EdgeInsets.fromLTRB(18, 12, 0, 12),


              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Builds the checkbox widget on each date tile.
                  LinkDateCheckbox(date: widget.date,),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Returns the display name widget on datetile
                        Text(
                          currentContact.displayName,
                          style: (widget.date.isComplete != null && widget.date.isComplete == true) ? const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.lineThrough
                          )
                              : const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 3,
                        ),

                        // Returns the nature of meeting widget on datetile
                        Text(
                          widget.date.meetingType ?? '-',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: Constants.kSecondaryColor),
                        ),

                      ],
                    ),
                  ),

                  WidgetDatePopupMenu(currentDate: widget.date),

                ],
              ),
            ),
          );
  }
}


///--------------------------------------------------------------
/// Widget for the checkbox
///--------------------------------------------------------------

class LinkDateCheckbox extends StatefulWidget {
  const LinkDateCheckbox({
    Key? key,
    required this.date
  }) : super(key: key);

  final ForgeDates date;

  @override
  State<LinkDateCheckbox> createState() => _LinkDateCheckboxState();
}

class _LinkDateCheckboxState extends State<LinkDateCheckbox> {


  Color borderColor = Constants.kPrimaryColor;

  @override
  Widget build(BuildContext context) {

    /// Sets it to purple if in time, red if overdue
    if (widget.date.meetingDate != null) {
      borderColor = widget.date.meetingDate!.compareTo(DateUtils.dateOnly(DateTime.now())) < 0 ? Constants.kErrorColor : Constants.kPrimaryColor;
    }

    return SizedBox(
      height: 40,
      width: 40,
      child: Transform.scale(
        scale: 1.5,
        child: StatefulBuilder(
          builder: (context, _setState) => Checkbox(

              side: BorderSide(color: borderColor, width: 2),
              activeColor: Constants.kSecondaryColor,
              value: widget.date.isComplete ?? false,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),

              onChanged: (bool? newValue) {

                HapticFeedback.lightImpact();
                _setState(() {

                  // Changes the value of the checkbox and updates the box
                   LinkDateServices
                       .onTapCheckbox(newValue, widget.date);

                });

              }
              ),
        ),
      ),
    );
  }
}


///--------------------------------------------------------------
/// Date Divider
///--------------------------------------------------------------

Widget DateDivider ({required String divText}) {

  bool isToday = DateFormat('EEE, d MMM y').format(DateTime.now()).toUpperCase() == divText;

  return Padding(
    padding: const EdgeInsets.fromLTRB(18, 5, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          divText,
          style: TextStyle(
            color: isToday ? Constants.kPrimaryColor : Constants.kSecondaryColor,
            fontSize: 14,
          ),
        ),
        Expanded(child: Divider(
          indent: 10,
          color: Colors.grey.shade200,
        ))
      ],
    ),
  );

}



///--------------------------------------------------------------
/// Widget Date PopupMenu
///--------------------------------------------------------------


class WidgetDatePopupMenu extends StatelessWidget {
  WidgetDatePopupMenu({Key? key, required this.currentDate}) : super(key: key);

  ForgeDates currentDate;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, color: Constants.kSecondaryColor,),
        onSelected: (val) {

        },

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        itemBuilder: (context) => [

          /// Edits the date
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.edit),
                contentPadding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                visualDensity: VisualDensity(vertical: -4),
                minLeadingWidth: 5,
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(useRootNavigator: false, context: context, builder: (context) => DialogAddNewLinkDate(initDate: currentDate,));
                },
              ),
          ),


          /// Deletes the date
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.delete),
              contentPadding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
              visualDensity: VisualDensity(vertical: -4),
              minLeadingWidth: 5,
              title: const Text('Delete'),
              onTap: () {

                if (currentDate.linkid != null ) {
                  ForgeLinks? currentLink = LinkDateServices.getLinkfromid(currentDate.linkid!);

                  if (currentLink != null ) {
                    currentLink.linkDates.removeWhere((element) => element == currentDate);
                    Box linksBox = Hive.box(Constants.linksBox);
                    linksBox.put(currentLink.id, currentLink);
                  }
                }

                Navigator.pop(context);
              },
            ),
          ),



        ]
    );
  }
}
