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
      displayName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ForgeLinks obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName);
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
