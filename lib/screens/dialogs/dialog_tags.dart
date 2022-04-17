import 'package:flutter/material.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import '../../models/links_model.dart';
import '../../models/tags_model.dart';
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
  Box tagsBox = Hive.box(Constants.tagsBox);
  Box linksBox = Hive.box(Constants.linksBox);
  LinkTag currentTag = LinkTag();
  int? _selectvalue;

  @override
  Widget build(BuildContext context) {

    /*****************************************************************
    Initialization of values
    *****************************************************************/

    ForgeLinks currentLink = LinkDateServices().getLinkfromid(widget.currentID);
    List<LinkTag> tagsList =
        tagsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();

    if (currentLink.tagID != null) {
      currentTag = tagsList[
          tagsList.indexWhere((element) => element.tagID == currentLink.tagID)];
      _selectvalue = tagsList.indexWhere((element) => element.tagID == currentLink.tagID);
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
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
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
