// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelExpenseModelAdapter extends TypeAdapter<TravelExpenseModel> {
  @override
  final int typeId = 6;

  @override
  TravelExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelExpenseModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TravelExpenseModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.travelDayId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
