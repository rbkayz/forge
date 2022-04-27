import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/prefs_model.dart';
import 'package:forge/screens/dialogs/dialog_datepicker.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/links_model.dart';
import '../dialogs/dialog_tags.dart';

///--------------------------------------------------------------
/// Links tag
///--------------------------------------------------------------

class WidgetTag extends StatefulWidget {
  WidgetTag({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<WidgetTag> createState() => _WidgetTagState();
}

class _WidgetTagState extends State<WidgetTag> {

  // Initialize the currentTag with the no tag set value
  LinkTag currentTag = LinkTag(tagName: 'NO TAG', tagColor: Colors.grey.shade100.value);

  // Variable for the currentTagID. If null, then no tag is set
  int? currentTagID;

  @override
  Widget build(BuildContext context) {

    // Retrieves the current Link from the link service
    ForgeLinks? currentLink = LinkDateServices.getLinkfromid(widget.id);

    currentTagID = currentLink?.tagID;

    Box prefsBox = Hive.box(Constants.prefsBox);
    List<LinkTag> tagsList = prefsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();

    if (currentTagID != null) {

      // Cycles through the list of tags to find tagID that is the same as the tagID of the currentLink
      int foundindex =
          tagsList.indexWhere((element) => element.tagID == currentTagID);

      // if found, then assigns the value of that tag to the currentTag;
      if (foundindex >= 0) {
        currentTag = tagsList[
            tagsList.indexWhere((element) => element.tagID == currentTagID)];
      }
    }


    return Material(

      // Checks if currentTag is null. If yes, returns grey, else returns the color
      color: currentTagID == null ? Colors.grey.shade100 : Color(currentTag.tagColor!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();

          if (tagsList.isNotEmpty) {

            // Shows bottom sheet if tagsList is not empty
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                elevation: 20,
                builder: (context) {
                  return DialogTagSelector(currentID: widget.id);
                }).then((_) => updateState());
          }

          else {

            // If tagslist is empty, then navigates to the edit tags page
            Navigator.pushNamed(context, Constants.editTagsNavigate).then((value) => updateState());

          }
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            currentTagID == null ? 'NO TAG' : '# ${currentTag.tagName?.toUpperCase()}',
            style: const TextStyle(fontSize: 12, color: Constants.kBlackColor),
          ),
        ),
      ),
    );
  }

  updateState() {
    setState(() {});
  }
}

///--------------------------------------------------------------
/// Calendar Widget for the next meeting
///--------------------------------------------------------------

class NextConnectDateWidget extends StatefulWidget {
  const NextConnectDateWidget({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<NextConnectDateWidget> createState() => _NextConnectDateWidgetState();
}

class _NextConnectDateWidgetState extends State<NextConnectDateWidget> {
  DateTime? newDate;

  /// Function that updates the value in the next date box
  Future _changeDate() async {
    if (LinkDateServices.isLinkActive(widget.id)) {
      HapticFeedback.lightImpact();
      newDate = await DatePickerService().changeDate(context, widget.id);
    } else {
      HapticFeedback.lightImpact();

      await LinkDateServices.activateLink(context, widget.id);

      newDate = await DatePickerService().changeDate(context, widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    ForgeDates nextDate = LinkDateServices.getNextDate(widget.id);

    return Tooltip(
      message: 'Upcoming meeting date. Press to edit.',
      child: SizedBox(
        width: 50,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Constants.kWhiteColor,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero),
          onPressed: () async {
            /// Updates the value in the box
            _changeDate().then((value) {
              setState(() {});
            });
          },
          child: nextDate.linkid != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 27,
                      child: FittedBox(
                        child: Text(
                          DateFormat('d')
                              .format(nextDate.meetingDate!)
                              .padLeft(2, '0'),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: FittedBox(
                        child: Text(
                            DateFormat('MMM')
                                .format(nextDate.meetingDate!)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Constants.kBlackColor,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('--',
                      style: TextStyle(color: Constants.kBlackColor)),
                ),
        ),
      ),
    );
  }
}

///--------------------------------------------------------------
/// The Link Progress bar
///--------------------------------------------------------------

class LinkProgressBar extends StatefulWidget {
  LinkProgressBar({Key? key}) : super(key: key);

  @override
  _LinkProgressBarState createState() => _LinkProgressBarState();
}

class _LinkProgressBarState extends State<LinkProgressBar> {
  @override
  Widget build(BuildContext context) {
    String currentID = Provider.of<String>(context);
    ForgeLinks currentLink = LinkDateServices.getLinkfromid(currentID) ?? ForgeLinks(id: currentID);
    ForgeDates prevDate = LinkDateServices.getPrevDate(currentID);
    ForgeDates nextDate = LinkDateServices.getNextDate(currentID);

    String first_row = prevDate.linkid != null
        ? 'Last connected on ${DateFormat('d MMM yyyy').format(prevDate.meetingDate!)} (${DateTime.now().difference(prevDate.meetingDate!).inDays} days ago)'
        : 'No previous connects available';

    String second_row = (currentLink.recurringEnabled == true && currentLink.recurringNum != null && currentLink.recurringType != null)
        ? 'Repeats every ${currentLink.recurringNum!} ${currentLink.recurringType!.toLowerCase()}'
        : 'Does not repeat';

    String third_row = nextDate.linkid != null
        ? 'Next connect is in ${nextDate.meetingDate!.difference(DateTime.now()).inDays} days'
        : 'No connects scheduled';

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              LinkHeaderRowWidget(icon: Icons.event_outlined, text: first_row),
              const SizedBox(height: 12),
              LinkHeaderRowWidget(
                  icon: Icons.repeat, text: second_row),
              const SizedBox(height: 12),
              LinkHeaderRowWidget(
                  icon: Icons.upcoming_outlined, text: third_row),
            ],
          ),
        ),
      ],
    );
  }
}

///--------------------------------------------------------------
/// Link header row (three rows)
///--------------------------------------------------------------

class LinkHeaderRowWidget extends StatelessWidget {
  const LinkHeaderRowWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey.shade700,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            )),
      ],
    );
  }
}

///--------------------------------------------------------------
/// Get two initials of the name. If not return a -
///--------------------------------------------------------------

String getInitials(List<String> nameParts) {
  try {
    if (nameParts.length > 1) {
      return nameParts[0].characters.first.toUpperCase() +
          nameParts[1].characters.first.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0].characters.first.toUpperCase();
    } else {
      return '-';
    }
  } on Exception catch (e) {
    print(e.toString());
    return '-';
  }
}

///--------------------------------------------------------------
/// Builds the circle avatar for the contact
///--------------------------------------------------------------

class ContactCircleAvatar extends StatefulWidget {
  const ContactCircleAvatar(
      {Key? key, required this.currentContact, this.radius = 20})
      : super(key: key);

  final Contact currentContact;
  final double? radius;

  @override
  _ContactCircleAvatarState createState() => _ContactCircleAvatarState();
}

class _ContactCircleAvatarState extends State<ContactCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    Uint8List? currentContactImage = widget.currentContact.photoOrThumbnail;
    List<String> nameParts = widget.currentContact.displayName.split(" ");
    String initials = getInitials(nameParts);

    return (currentContactImage == null)
        ? CircleAvatar(
            child: Text(initials),
            radius: widget.radius,
          )
        : CircleAvatar(backgroundImage: MemoryImage(currentContactImage));
  }
}
