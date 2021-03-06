import 'package:hive/hive.dart';

part 'links_model.g.dart';

@HiveType(typeId: 0)
class ForgeLinks extends HiveObject {

  ForgeLinks({required this.id, this.isActive = false, this.linkDates = const []});

  @HiveField(0)
  String id;

  @HiveField(2)
  bool isActive;

  @HiveField(3)
  List<ForgeDates> linkDates;

  @HiveField(4)
  int? tagID;

  @HiveField(5)
  String? note;

  @HiveField(6)
  DateTime? lastUpdateNote;

  @HiveField(7)
  int? recurringNum;

  @HiveField(8)
  String? recurringType;

  @HiveField(9)
  bool? recurringEnabled;

  String get linkKey {
    return id;
  }

}

@HiveType(typeId: 1)
class ForgeDates extends HiveObject {

  ForgeDates({this.meetingDate, this.meetingType, this.isComplete, this.linkid, this.annual});

  @HiveField(0)
  DateTime? meetingDate;

  @HiveField(1)
  String? meetingType;

  @HiveField(2)
  bool? isComplete;

  @HiveField(3)
  String? linkid;

  @HiveField(4)
  bool? annual;

  Map<String, dynamic> toMap(){
    return {
      "meetingDate": meetingDate,
      "meetingType": meetingType,
      "isComplete": isComplete,
      "linkid": linkid,
      "annual": annual,
      // and so on
    };
  }


}
