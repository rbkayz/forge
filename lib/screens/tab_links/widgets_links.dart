import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/models/tags_model.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:forge/utilities/widget_styles.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/links_model.dart';

///--------------------------------------------------------------
/// Links tag
///--------------------------------------------------------------

class WidgetTag extends StatelessWidget {
  WidgetTag({Key? key, required this.id}) : super(key: key);

  final String id;
  LinkTag currentTag = LinkTag(tagName: 'NO TAG', tagColor: Colors.grey.shade100.value);

  @override
  Widget build(BuildContext context) {

    ForgeLinks currentLink = LinkDateServices().getLinkfromid(id);

    int? currentTagID = currentLink.tagID;

    if (currentTagID != null) {
      Box tagsBox = Hive.box(Constants.tagsBox);
      List<LinkTag> tagsList = tagsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();
      currentTag = tagsList[tagsList.indexWhere((element) => element.tagID == currentTagID)];
    }

    return Container(
      padding: const EdgeInsets.all(3),
      child: Text(
        '# ${currentTag.tagName?.toUpperCase()}',
        style: const TextStyle(fontSize: 12, color: Constants.kBlackColor),
      ),
      decoration: BoxDecoration(
        color: Color(currentTag.tagColor!),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

///--------------------------------------------------------------
/// Calendar Widget for the next meeting
///--------------------------------------------------------------

class NextConnectDateWidget extends StatelessWidget {
  const NextConnectDateWidget({Key? key, required this.id})
      : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {

    ForgeDates nextDate = LinkDateServices().getNextDate(id);

    return Stack(children: <Widget>[
      Container(
        alignment: Alignment.center,
        decoration: forgeBoxDecoration(),
        height: 60,
        width: 50,
        child: nextDate.linkid != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 27,
                    child: FittedBox(
                      child: Text(DateFormat('d')
                          .format(nextDate.meetingDate!)
                          .padLeft(2, '0')),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    child: FittedBox(
                      child: Text(DateFormat('MMM')
                          .format(nextDate.meetingDate!)
                          .toUpperCase()),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text('-'),
              ),
      ),
    ]);
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

    Contact currentContact = Provider.of<Contact>(context);
    ForgeDates prevDate = LinkDateServices().getPrevDate(currentContact.id);
    ForgeDates nextDate = LinkDateServices().getNextDate(currentContact.id);


    String first_row = prevDate.linkid != null
        ? 'Last connected on ${DateFormat('d MMM yyyy').format(prevDate.meetingDate!)} (${prevDate.meetingDate!.difference(DateTime.now()).inDays} days ago)'
        : 'No previous connects available';

    String third_row = nextDate.linkid != null ?
        'Next connect is in ${nextDate.meetingDate!.difference(DateTime.now()).inDays} days'
        : 'No connects scheduled';

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              LinkHeaderRowWidget(icon: Icons.event_outlined, text: first_row),

              const SizedBox(height: 12),

              const LinkHeaderRowWidget(
                  icon: Icons.repeat, text: 'Repeats every 3 months'),

              const SizedBox(height: 12),

              LinkHeaderRowWidget(
                  icon: Icons.upcoming_outlined,
                  text: third_row),
            ],
          ),
        ),
      ],
    );
  }
}

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
