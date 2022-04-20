import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/screens/tab_timeline/widget_timeline.dart';
import 'package:forge/services/links_service.dart';
import 'package:forge/utilities/constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/links_model.dart';
import '../../../services/contacts_service.dart';
import '../../../services/listenables.dart';

class ContactTimelineTab extends StatefulWidget {
  const ContactTimelineTab({Key? key}) : super(key: key);

  @override
  State<ContactTimelineTab> createState() => _ContactTimelineTabState();
}

class _ContactTimelineTabState extends State<ContactTimelineTab> {

  final linksBox = Hive.box(Constants.linksBox);
  final prefsBox = Hive.box(Constants.prefsBox);

  @override
  Widget build(BuildContext context) {

    String currentID = Provider.of<String>(context);
    ForgeLinks? currentLink = LinkDateServices().getLinkfromid(currentID);

    List<ForgeDates> linkDates = currentLink?.linkDates ?? [];


    return ValueListenableBuilder2(
      first: linksBox.listenable(),
      second: prefsBox.listenable(),
      builder: (BuildContext context, a, b, Widget? child) {

        linkDates.sort((a, b) {
          DateTime meetingDate1 = a.meetingDate ?? DateTime.now().add(const Duration(days: 5000));
          DateTime meetingDate2 = b.meetingDate ?? DateTime.now().add(const Duration(days: 5000));
          return meetingDate1.compareTo(meetingDate2);
        });

        return ListView.builder(
          itemCount: linkDates.length,
          itemBuilder: (context, index) {

            ForgeDates date = linkDates[index];


            return date.meetingDate == null ? const SizedBox.shrink() :

            Container(

                // 18 px padding on Left to align with Forge
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      LinkDateCheckbox(date: date),

                      const SizedBox(
                        width: 8,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Returns the display name widget on datetile
                          Text(
                            date.meetingType ?? '------',
                            overflow: TextOverflow.ellipsis,
                            style: date.isComplete! ? const TextStyle(
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
                            DateFormat('MMM d').format(date.meetingDate!),
                            style: const TextStyle(
                                fontSize: 14, color: Constants.kSecondaryColor),
                          ),

                        ],
                      ),

                    ]
                )
            );
          }
          );
      },
    );
  }
}