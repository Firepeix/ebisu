// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelDayModelAdapter extends TypeAdapter<TravelDayModel> {
  @override
  final int typeId = 5;

  @override
  TravelDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelDayModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TravelDayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.budget);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
