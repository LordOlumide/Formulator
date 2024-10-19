// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formula.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormulaAdapter extends TypeAdapter<Formula> {
  @override
  final int typeId = 0;

  @override
  Formula read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Formula(
      name: fields[0] as String,
      sections: (fields[1] as List).cast<Section>(),
    );
  }

  @override
  void write(BinaryWriter writer, Formula obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormulaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
