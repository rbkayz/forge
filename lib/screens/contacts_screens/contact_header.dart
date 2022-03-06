import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:forge/components/appbar.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/contacts_screens/contact_body_history.dart';
import 'package:forge/screens/contacts_screens/contact_body_notes.dart';
import 'package:forge/utilities/constants.dart';

import 'contact_body_details.dart';

class ContactDetail extends StatefulWidget {

  const ContactDetail({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(currentContact: widget.currentContact),
      body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                      [
                        profileHeader(context, widget.currentContact),
                      ]
                  ),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                const TabBar(
                  labelColor: Constants.kPrimaryColor,
                    unselectedLabelColor: Constants.kSecondaryColor,
                    tabs: [
                      Tab(text: 'Details'),
                      Tab(text: 'History'),
                      Tab(text: 'Notes'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    ContactDetailsTab(currentContact: widget.currentContact,),
                    const ContactHistoryTab(),
                    const ContactNotesTab(),
                  ]),
                )
              ],
            ),
          ),
      ),
    );
  }
}


Widget profileHeader(BuildContext context, Contact currentContact) {

  Uint8List? currentContactImage = currentContact.photoOrThumbnail;
  List<String> nameparts = currentContact.displayName.split(" ");
  String initials = nameparts[0].characters.first.toUpperCase() + nameparts[1].characters.first.toUpperCase();

  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Constants.kWhiteColor),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (currentContactImage == null) ?
              CircleAvatar(
                  radius: 40,
                  backgroundColor: Constants.kPrimaryColor,
                  child: Text(
                      initials,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Constants.kWhiteColor,
                    ),
                  )
              ) :
              CircleAvatar(
                radius: 40,
                backgroundColor: Constants.kPrimaryColor,
                backgroundImage:
                MemoryImage(currentContactImage)
              ),
              Row(
                children: [
                  Column(
                    children: const [
                      Text(
                        "23",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0.4,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: const [
                      Text(
                        "1.5M",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: const [
                      Text(
                        "234",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            currentContact.displayName,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Lorem Ipsum",
            style: TextStyle(
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          actions(context),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}

Widget actions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: OutlinedButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text("Edit Profile", style: TextStyle(color: Constants.kBlackColor)),
          ),
          style: OutlinedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(0, 30),
              side: const BorderSide(
                color: Constants.kSecondaryColor,
              )),
          onPressed: () {},
        ),
      ),
    ],
  );
}
