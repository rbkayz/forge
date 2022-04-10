import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:forge/components/appbar.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:forge/screens/tab_links/contacts_screens/contact_body_history.dart';
import 'package:forge/screens/tab_links/contacts_screens/contact_body_notes.dart';
import 'package:forge/screens/tab_links/widgets_links.dart';
import 'package:forge/screens/tab_links/contacts_screens/widget_contacts.dart';
import 'package:forge/utilities/constants.dart';

import 'contact_body_info.dart';

class ContactDetail extends StatefulWidget {

  const ContactDetail({Key? key, required this.currentContact}) : super(key: key);

  final Contact currentContact;

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {

  late ScrollController _controller;
  bool _isScrolled = false;

  _scrollListener() {
    if (_controller.offset >= 60 && _isScrolled == false) {
      setState(() {
        _isScrolled = true;
      });
    } else if(_controller.offset <= 60 && _isScrolled == true) {
       setState(() {
         _isScrolled = false;
       });
    }

  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //print(_controller.offset);

    return Scaffold(
      appBar: ContactAppBar(currentContact: widget.currentContact, isScrolled: _isScrolled),
      body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: _controller,
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
                      Tab(text: 'Info'),
                      Tab(text: 'History'),
                      Tab(text: 'Notes'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    ContactInfoTab(currentContact: widget.currentContact,),
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

  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Constants.kWhiteColor),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContactCircleAvatar(currentContact: currentContact,radius: 30,),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    currentContact.displayName,
                    style: const TextStyle(
                      color: Constants.kBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  const LinksTag(),

                ],
              ),
              const Expanded(child: SizedBox.shrink()),
              
              const NextConnectDateWidget(),
              
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          LinkProgressBar(start: DateTime(2022,3,1), end: DateTime(2022,3,31)),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
//
// Widget actions(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Expanded(
//         child: OutlinedButton(
//           child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 0),
//             child: Text("Edit Profile", style: TextStyle(color: Constants.kBlackColor)),
//           ),
//           style: OutlinedButton.styleFrom(
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               minimumSize: const Size(0, 30),
//               side: const BorderSide(
//                 color: Constants.kSecondaryColor,
//               )),
//           onPressed: () {},
//         ),
//       ),
//     ],
//   );
// }
