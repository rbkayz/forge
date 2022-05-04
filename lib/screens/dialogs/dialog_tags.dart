import 'package:flutter/material.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import '../../models/links_model.dart';
import '../../models/prefs_model.dart';
import '../../services/auth.dart';
import '../../utilities/constants.dart';
import '../tab_settings/widget_settings/edit_tags.dart';

///--------------------------------------------------------------
/// Dialog (Bottom sheet) to select tags
///--------------------------------------------------------------

class DialogTagSelector extends StatefulWidget {
  DialogTagSelector({Key? key, required this.currentID}) : super(key: key);

  final String currentID;

  @override
  State<DialogTagSelector> createState() => _DialogTagSelectorState();
}

class _DialogTagSelectorState extends State<DialogTagSelector> {


  LinkTag currentTag = LinkTag();
  int? _selectvalue;

  @override
  Widget build(BuildContext context) {

    /*****************************************************************
    Initialization of values
    *****************************************************************/

    Box linksBox = Hive.box(FirebaseAuthService.getLinksBox(context));
    Box prefsBox = Hive.box(FirebaseAuthService.getPrefsBox(context));

    ForgeLinks? currentLink = LinkDateServices.getLinkfromid(widget.currentID, context);
    List<LinkTag> tagsList =
        prefsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();

    if (currentLink!.tagID != null) {

      int foundIndex =  tagsList.indexWhere((element) => element.tagID == currentLink.tagID);

      if (foundIndex >=0 ) {
        currentTag = tagsList[foundIndex];
        _selectvalue = foundIndex;
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'EDIT TAG',
                    style: TextStyle(
                        fontSize: 18,
                        color: Constants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                  TextButton(
                      onPressed: () {
                        currentLink.tagID = null;
                        linksBox.put(currentLink.linkKey, currentLink);

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete Tag',
                        style: TextStyle(
                            fontSize: 12, color: Constants.kSecondaryColor),
                      ))
                ],
              ),
            ),
            ListView.builder(
                  shrinkWrap: true,
                  itemCount: tagsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minLeadingWidth: 20,
                      title: Row(children: [
                        WidgetTagTile(currentTag: tagsList[index]),
                      ]),
                      leading: Icon(
                        Icons.tag,
                        color: Color(tagsList[index].tagColor ??
                            Constants.kSecondaryColor.value),
                      ),
                      trailing: Radio(groupValue: _selectvalue, value: index, onChanged: (int? value) {

                        setState(() {

                          _selectvalue = value!;
                          currentLink.tagID = tagsList[value].tagID;
                          linksBox.put(currentLink.linkKey, currentLink);

                        });

                        Navigator.pop(context);

                      },),
                    );
                  }),
          ],
        ),
    );
  }
}
