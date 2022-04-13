import 'package:hive/hive.dart';

part 'tags_model.g.dart';

@HiveType(typeId: 2)
class ForgeTags extends HiveObject {

  ForgeTags({this.tagsList = const []});

  @HiveField(0)
  List<LinkTag> tagsList;


}


@HiveType(typeId: 3)
class LinkTag extends HiveObject {

  LinkTag({this.tagName, this.tagColor});

  @HiveField(0)
  String? tagName;

  @HiveField(1)
  int? tagColor;

  Map<String, dynamic> toMap(){
    return {
      "tagName": tagName,
      "tagColor": tagColor,
    };
  }


}