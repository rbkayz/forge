import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:forge/services/links_service.dart';
import '../../models/links_model.dart';
import '../../utilities/constants.dart';


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
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),


              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Builds the checkbox widget on each date tile.
                  LinkDateCheckbox(date: widget.date,),

                  const SizedBox(
                    width: 8,
                  ),

                  Column(
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
                ],
              ),
            ),
          );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Transform.scale(
        scale: 1.5,
        child: StatefulBuilder(
          builder: (context, _setState) => Checkbox(

              side: const BorderSide(color: Constants.kPrimaryColor, width: 2),
              activeColor: Constants.kSecondaryColor,
              value: widget.date.isComplete ?? false,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),

              onChanged: (bool? newValue) {

                HapticFeedback.lightImpact();
                _setState(() {

                  // Changes the value of the checkbox and updates the box
                  LinkDateServices()
                      .onTapCheckbox(newValue, widget.date);
                  widget.date.isComplete = newValue;
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

  return Padding(
    padding: const EdgeInsets.fromLTRB(18, 5, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          divText,
          style: const TextStyle(
            color: Constants.kSecondaryColor,
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