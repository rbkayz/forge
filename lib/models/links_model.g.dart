// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForgeLinksAdapter extends TypeAdapter<ForgeLinks> {
  @override
  final int typeId = 0;

  @override
  ForgeLinks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForgeLinks(
      id: fields[0] as String,
      isActive: fields[2] as bool,
      linkDates: (fields[3] as List).cast<ForgeDates>(),
    )
      ..tagID = fields[4] as int?
      ..note = fields[5] as String?
      ..lastUpdateNote = fields[6] as DateTime?
      ..recurringNum = fields[7] as int?
      ..recurringType = fields[8] as String?
      ..recurringEnabled = fields[9] as bool?;
  }

  @override
  void write(BinaryWriter writer, ForgeLinks obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.linkDates)
      ..writeByte(4)
      ..write(obj.tagID)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.lastUpdateNote)
      ..writeByte(7)
      ..write(obj.recurringNum)
      ..writeByte(8)
      ..write(obj.recurringType)
      ..writeByte(9)
      ..write(obj.recurringEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgeLinksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForgeDatesAdapter extends TypeAdapter<ForgeDates> {
  @override
  final int typeId = 1;

  @override
  ForgeDates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForgeDates(
      meetingDate: fields[0] as DateTime?,
      meetingType: fields[1] as String?,
      isComplete: fields[2] as bool?,
      linkid: fields[3] as String?,
      annual: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ForgeDates obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.meetingDate)
      ..writeByte(1)
      ..write(obj.meetingType)
      ..writeByte(2)
      ..write(obj.isComplete)
      ..writeByte(3)
      ..write(obj.linkid)
      ..writeByte(4)
      ..write(obj.annual);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgeDatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
