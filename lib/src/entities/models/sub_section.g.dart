// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubSectionAdapter extends TypeAdapter<SubSection> {
  @override
  final int typeId = 2;

  @override
  SubSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubSection(
      name: fields[0] as String,
      weight: fields[1] as double,
      entries: (fields[2] as List).cast<Entry>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubSection obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.entries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
