
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../components/appbar.dart';
import '../../../models/tags_model.dart';
import '../../../utilities/constants.dart';

class TagsEditor extends StatefulWidget {
  TagsEditor({Key? key}) : super(key: key);

  @override
  State<TagsEditor> createState() => _TagsEditorState();
}

class _TagsEditorState extends State<TagsEditor> {
  final tagsBox = Hive.box(Constants.tagsBox);
  var tagsList;

  @override
  Widget build(BuildContext context) {

    tagsList = tagsBox.get('tags', defaultValue: <LinkTag>[]);

    tagsList.clear();
    tagsList.add(LinkTag(tagName: 'Test tag', tagColor: Constants.kSecondaryColor.value));

    tagsBox.put('tags', tagsList);

    return Scaffold(
      appBar: const ForgeAppBar(
        title: 'Edit Tags',
      ),
      body: tagsList.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: tagsList.length,
              itemBuilder: (context, index) {
                LinkTag currentTag = tagsList[index];
                return ListTile(
                  minLeadingWidth: 30,
                  leading: Icon(Icons.tag, color: currentTag.tagColor == null ? Constants.kSecondaryColor : Color(currentTag.tagColor!),),
                  title: Text(currentTag.tagName?.toUpperCase() ?? 'NO NAME SET'),
                );
              },
            ),
    );
  }
}
