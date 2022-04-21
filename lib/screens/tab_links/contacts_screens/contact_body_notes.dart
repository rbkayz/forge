import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../models/links_model.dart';
import '../../../services/links_service.dart';
import '../../../utilities/constants.dart';
import 'package:intl/intl.dart';

class ContactNotesTab extends StatefulWidget {
  ContactNotesTab({Key? key, required this.contactController}) : super(key: key);

  final ScrollController contactController;

  @override
  State<ContactNotesTab> createState() => _ContactNotesTabState();
}

class _ContactNotesTabState extends State<ContactNotesTab> {
  final TextEditingController _notesController = TextEditingController();

  bool switchval = false;


  /// Update the note and store it in the linksbox
  void updateNoteInBox(ForgeLinks currentLink) {

    if(_notesController.text != currentLink.note) {

      currentLink.note = _notesController.text;
      Box linksBox = Hive.box(Constants.linksBox);
      currentLink.lastUpdateNote = DateUtils.dateOnly(DateTime.now());
      linksBox.put(currentLink.id, currentLink);

    }

  }


  /// Toggles the edit function on the notes screen. Offsets the screen position, and updates note
  void editNotes(bool val, ForgeLinks currentLink) {

      if(val) {

        if(widget.contactController.offset == 0) {
          widget.contactController.animateTo(170, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }

      }

      else {
        widget.contactController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        FocusManager.instance.primaryFocus?.unfocus();
        updateNoteInBox(currentLink);
      }

  }


  @override
  void dispose() {

    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String currentID = Provider.of<String>(context);
    ForgeLinks currentLink = LinkDateServices().getLinkfromid(currentID) ?? ForgeLinks(id: currentID);

    String currentNote = currentLink.note ?? '';
    DateTime? lastUpdatedNote = currentLink.lastUpdateNote;
    String lastUpdated = lastUpdatedNote == null ? '-' : DateFormat('MMM d').format(lastUpdatedNote);
    _notesController.text = currentNote;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) _setState) {
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Last updated on $lastUpdated',
                    style: const TextStyle(
                        fontSize: 12, color: Constants.kSecondaryColor)),
                const Expanded(child: SizedBox.shrink()),
                Transform.scale(
                    scale: 0.7,
                    child: Switch(
                        value: switchval,
                        onChanged: (val) {
                          _setState(() {
                            switchval = val;
                            editNotes(val, currentLink);
                          });
                        })),
                Text('Edit mode',
                    style: TextStyle(
                        fontSize: 12,
                        color: switchval
                            ? Constants.kPrimaryColor
                            : Constants.kSecondaryColor)),
              ],
            ),
            TextField(
              controller: _notesController,
              enabled: switchval,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  hintText:
                      'Add any details like their partners name, kids, pets, interests, past conversations, etc.',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  border: InputBorder.none),
            ),
          ]);
        }));
  }
}
