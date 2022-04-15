import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../../components/appbar.dart';
import '../../../models/tags_model.dart';
import '../../../utilities/constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagsEditor extends StatefulWidget {
  TagsEditor({Key? key}) : super(key: key);

  @override
  State<TagsEditor> createState() => _TagsEditorState();
}

class _TagsEditorState extends State<TagsEditor> {

  final tagsBox = Hive.box(Constants.tagsBox);
  late List<LinkTag> tagsList;
  late LinkTag? newTag;


  ///--------------------------------------------------------------
  /// Build method
  ///--------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    tagsList = tagsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();

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
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                  minLeadingWidth: 27,
                  leading: Icon(
                    Icons.tag,
                    color: currentTag.tagColor == null
                        ? Constants.kSecondaryColor
                        : Color(currentTag.tagColor!) ,
                  ),

                  title: Row(children: [

                    DecoratedBox(
                      decoration: BoxDecoration(color: Color(currentTag.tagColor!), borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                        child: Text('${currentTag.tagName?.toUpperCase()}',
                            style: TextStyle(
                                fontSize: 14,
                                color: useWhiteForeground(Color(currentTag.tagColor!)) ? Colors.white : Colors.black)),
                      ),
                    ),
                  ]),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      //Edit button
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.edit,
                          color: Constants.kSecondaryColor,
                          size: 18,
                        ),
                        onPressed: () async {

                          newTag = await showDialog(context: context, builder: (context) => WidgetTagDialog(initialTag: currentTag,));

                          setState(() {

                            if (newTag != null) {

                              tagsList[tagsList.indexWhere((element) => element.tagID == newTag?.tagID)] = newTag!;
                              tagsBox.put('tags', tagsList);
                            }

                          });

                        },
                      ),


                      //Delete button
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete,
                          color: Constants.kSecondaryColor,
                          size: 18,
                        ),
                        onPressed: () async {

                          newTag = LinkTag();

                          bool? toDelete = await showDialog(context: context, builder: (context) {

                            return AlertDialog(
                              title: const Text('Confirm Deletion', style: TextStyle(color: Constants.kBlackColor),),
                              content: const Text('Deleting this tag cannot be reversed. Are you sure you want to continue?'),
                              actions: [
                                TextButton(onPressed: () {Navigator.pop(context, false);}, child: Text('Cancel', style: TextStyle(color: Constants.kBlackColor))),
                                TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text('Delete', style: TextStyle(color: Constants.kErrorColor),)),
                              ],
                            );

                          }
                          );

                          setState(() {
                            if (toDelete != null && toDelete == true) {
                              tagsList.removeWhere((element) => element.tagID == currentTag.tagID);

                              tagsBox.put('tags', tagsList);
                            }
                          });

                        },
                      ),


                    ],
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          newTag = await showDialog(context: context, builder: (context) => WidgetTagDialog());

          setState(() {

            if (newTag != null) {
              tagsList.add(newTag!);
              tagsBox.put('tags', tagsList);
            }

          });

        },
        child: const Icon(Icons.add),
      ),

    );
  }
}


///--------------------------------------------------------------
/// Dialog widget
///--------------------------------------------------------------


class WidgetTagDialog extends StatefulWidget {
  WidgetTagDialog({Key? key, this.initialTag}) : super(key: key);

  LinkTag? initialTag;
  LinkTag newTag = LinkTag();
  Color? newColorValue;

  @override
  State<WidgetTagDialog> createState() => _WidgetTagDialogState();

}

class _WidgetTagDialogState extends State<WidgetTagDialog> {

  final tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
        child: Dialog(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  //Get name field
                  WidgetTagNameTextField(initialTag: widget.initialTag, tagController: tagController),

                  //Get color picker
                  BlockPicker(
                    pickerColor: Color(widget.initialTag?.tagColor ?? Colors.red.shade200.value),
                    availableColors: tagColors,
                    onColorChanged: (newColor) {
                      widget.newColorValue = newColor;
                    },
                    itemBuilder: pickerItemBuilder,
                    layoutBuilder: layoutBuilder,
                  ),


                  Row(
                    children: [

                      //Cancel Button
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                onPressed: () {

                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(primary: Constants.kPrimaryColor,backgroundColor: Constants.kWhiteColor)
                            ),
                          )
                      ),


                      //Done button
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () {

                                if(_formKey.currentState!.validate()) {
                                  widget.newTag.tagName = tagController.text;

                                  widget.newTag.tagColor =
                                      widget.newColorValue?.value ??
                                          widget.initialTag?.tagColor ??
                                          Colors.red.shade200.value;
                                  widget.newTag.tagID =
                                      widget.initialTag?.tagID ??
                                          widget.newTag.hashCode;

                                  Navigator.pop(context, widget.newTag);
                                }
                              },
                              child: const Text('Done'),
                              style: OutlinedButton.styleFrom(primary: Constants.kWhiteColor,backgroundColor: Constants.kPrimaryColor),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),

          elevation: 20,

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),

          backgroundColor: Constants.kWhiteColor,
        ),
      ),
    );
  }
}



///--------------------------------------------------------------
/// Tag Name Text Field
///--------------------------------------------------------------

class WidgetTagNameTextField extends StatefulWidget {
  WidgetTagNameTextField({
    Key? key, this.initialTag, required this.tagController
  }) : super(key: key);

  final LinkTag? initialTag;
  final TextEditingController tagController;

  @override
  State<WidgetTagNameTextField> createState() => _WidgetTagNameTextFieldState();

}

class _WidgetTagNameTextFieldState extends State<WidgetTagNameTextField> {


  String? tagvalidator(text) {

      if (text == null || text.isEmpty) {
        return 'Tag name cannot be blank';
      }
      
      Box tagsBox = Hive.box(Constants.tagsBox);
      List<LinkTag> tagsList = tagsBox.get('tags', defaultValue: <LinkTag>[]).cast<LinkTag>();
      
      if (tagsList.where((element) => element.tagName == text).isNotEmpty && widget.initialTag?.tagName != text) {
        return 'Tag name already exists';
      }
      
      return null;

  }



  @override
  Widget build(BuildContext context) {

   widget.tagController.text = widget.initialTag?.tagName?.toUpperCase() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextFormField(
        validator: tagvalidator,
        textCapitalization: TextCapitalization.characters,
        controller: widget.tagController,
        inputFormatters: [UpperCaseTextFormatter()],
        maxLength: 12,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter the tag name',
          hintText: 'e.g. WORK or SCHOOL',
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.tagController.dispose();
    super.dispose();
  }
}

///--------------------------------------------------------------
/// Picker Item Builder
///--------------------------------------------------------------

Widget pickerItemBuilder(
    Color color, bool isCurrentColor, void Function() changeColor) {

  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: color,
      boxShadow: [
        BoxShadow(
            color: color.withOpacity(0.8),
            offset: const Offset(0, 1),
            blurRadius: 0.2)
      ],
    ),

    child: InkWell(
      onTap: changeColor,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isCurrentColor ? 1 : 0,
        child: Icon(
          Icons.done,
          size: 30,
          color: useWhiteForeground(color) ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}

///--------------------------------------------------------------
/// Upper case text formatter
///--------------------------------------------------------------

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}


///--------------------------------------------------------------
/// Color modifier
///--------------------------------------------------------------

Color colorModifier (Color color) {

  final hslColor = HSLColor.fromColor(color);
  final Color modColor = hslColor.withLightness(0.65).withAlpha(0.2).toColor();

  return modColor;

}

///--------------------------------------------------------------
/// Widget Layout Builder
///--------------------------------------------------------------


Widget layoutBuilder(
    BuildContext context, List<Color> colors, PickerItem child) {
  Orientation orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 300 : 200,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}