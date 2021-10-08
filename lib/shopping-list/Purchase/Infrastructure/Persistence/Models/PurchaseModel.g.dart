// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PurchaseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseHiveModelAdapter extends TypeAdapter<PurchaseHiveModel> {
  @override
  final int typeId = 3;

  @override
  PurchaseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseHiveModel(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
