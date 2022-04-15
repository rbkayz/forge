import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:forge/services/links_service.dart';
import 'package:hive/hive.dart';
import '../../models/links_model.dart';
import '../../models/tags_model.dart';
import '../../utilities/constants.dart';
import '../tab_settings/widget_settings/edit_tags.dart';

///--------------------------------------------------------------
/// Dialog widget
///--------------------------------------------------------------

class DialogTagSelector extends StatefulWidget {
  DialogTagSelector({Key? key, required this.currentID}) : super(key: key);

  final String currentID;

  @override
  State<DialogTagSelector> createState() => _DialogTagSelectorState();
}

class _DialogTagSelectorState extends State<DialogTagSelector> {
  Box tagsBox = Hive.box(Constants.tagsBox);
  LinkTag currentTag = LinkTag();

  @override
  Widget build(BuildContext context) {
    ForgeLinks currentLink = LinkDateServices().getLinkfromid(widget.currentID);
    List<LinkTag> tagsList =
        tagsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();

    if (currentLink.tagID != null) {
      currentTag = tagsList[
          tagsList.indexWhere((element) => element.tagID == currentLink.tagID)];
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Dialog(
          alignment: Alignment.center,
          elevation: 20,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Constants.kWhiteColor,
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tagsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        minLeadingWidth: 27,
                        title: Row(children: [
                          WidgetTagTile(currentTag: tagsList[index]),
                        ]));
                  })),
        ),
      ),
    );
  }
}
