import 'package:hive/hive.dart';

part 'links_model.g.dart';

@HiveType(typeId: 0)
class ForgeLinks extends HiveObject {

  ForgeLinks({required this.id, required this.displayName, this.isActive = false, this.linkDates = const []});

  @HiveField(0)
  String id;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  bool isActive;

  @HiveField(3)
  List<ForgeDates> linkDates;

  @HiveField(4)
  int? tagID;

  String get linkKey {
    return id;
  }

  String get linkName {
    return displayName;
  }

}

@HiveType(typeId: 1)
class ForgeDates extends HiveObject {

  ForgeDates({this.meetingDate, this.meetingType, this.isComplete, this.linkid});

  @HiveField(0)
  DateTime? meetingDate;

  @HiveField(1)
  String? meetingType;

  @HiveField(2)
  bool? isComplete;

  @HiveField(3)
  String? linkid;

  Map<String, dynamic> toMap(){
    return {
      "meetingDate": meetingDate,
      "meetingType": meetingType,
      "isComplete": isComplete,
      "linkid": linkid,
      // and so on
    };
  }


}
