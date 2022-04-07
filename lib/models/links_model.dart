import 'package:hive/hive.dart';

part 'links_model.g.dart';

@HiveType(typeId: 0)
class ForgeLinks extends HiveObject {

  ForgeLinks({required this.id, required this.displayName, this.isActive = false});

  @HiveField(0)
  String id;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  bool isActive;

  String get linkKey {
    return id;
  }

  String get linkName {
    return displayName;
  }

}

