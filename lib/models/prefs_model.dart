import 'package:hive/hive.dart';

part 'prefs_model.g.dart';

@HiveType(typeId: 2)
class ForgePrefs extends HiveObject {

  ForgePrefs({this.tagsList = const [], this.showAllDatesinTimeline = true});

  @HiveField(0)
  List<LinkTag> tagsList;

  @HiveField(1)
  bool showAllDatesinTimeline;


}


@HiveType(typeId: 3)
class LinkTag extends HiveObject {

  LinkTag({this.tagName, this.tagColor, this.tagID});

  @HiveField(0)
  String? tagName;

  @HiveField(1)
  int? tagColor;

  @HiveField(2)
  int? tagID;

  Map<String, dynamic> toMap(){
    return {
      "tagName": tagName,
      "tagColor": tagColor,
      "tagID": tagID,
    };
  }


}