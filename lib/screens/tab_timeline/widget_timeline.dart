import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:forge/services/contacts_service.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';

import '../../models/links_model.dart';
import '../../utilities/constants.dart';

class LinkDateTile extends StatefulWidget {
  LinkDateTile({Key? key, required this.date}) : super(key: key);

  final ForgeDates date;

  @override
  State<LinkDateTile> createState() => _LinkDateTileState();
}

class _LinkDateTileState extends State<LinkDateTile> {

  @override
  Widget build(BuildContext context) {

    final currentContact =
        AllContactsServices().getContactfromID(context, widget.date.linkid!);
    bool? _isSelected = widget.date.isComplete;

    return currentContact.displayName == ''
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Constants.contactDetailNavigate,
                  arguments: currentContact);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Transform.scale(
                          scale: 1.5,
                          child: StatefulBuilder(
                            builder: (context, _setState) => Checkbox(

                                side: const BorderSide(color: Constants.kPrimaryColor, width: 2),
                                activeColor: Constants.kSecondaryColor,
                                value: _isSelected,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: const CircleBorder(),

                                onChanged: (bool? newValue) {
                                  _setState(() {
                                    LinkDateServices()
                                        .onTapCheckbox(newValue, widget.date);
                                    _isSelected = newValue;
                                  });
                                }),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentContact.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            'Recurring meeting',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: Constants.kSecondaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}