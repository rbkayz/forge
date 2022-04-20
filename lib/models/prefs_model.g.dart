// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForgePrefsAdapter extends TypeAdapter<ForgePrefs> {
  @override
  final int typeId = 2;

  @override
  ForgePrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForgePrefs(
      tagsList: (fields[0] as List).cast<LinkTag>(),
      showAllDatesinTimeline: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ForgePrefs obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.tagsList)
      ..writeByte(1)
      ..write(obj.showAllDatesinTimeline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgePrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkTagAdapter extends TypeAdapter<LinkTag> {
  @override
  final int typeId = 3;

  @override
  LinkTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkTag(
      tagName: fields[0] as String?,
      tagColor: fields[1] as int?,
      tagID: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LinkTag obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tagName)
      ..writeByte(1)
      ..write(obj.tagColor)
      ..writeByte(2)
      ..write(obj.tagID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
