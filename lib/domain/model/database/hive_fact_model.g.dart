// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_fact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUserFactModelAdapter extends TypeAdapter<HiveUserFactModel> {
  @override
  final int typeId = 0;

  @override
  HiveUserFactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUserFactModel(
      id: fields[0] as int,
      fact: fields[1] as String,
      arrivingtime: fields[2] as String,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserFactModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fact)
      ..writeByte(2)
      ..write(obj.arrivingtime)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserFactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
