// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShoppingListModels.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingListHiveModelAdapter extends TypeAdapter<ShoppingListHiveModel> {
  @override
  final int typeId = 2;

  @override
  ShoppingListHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingListHiveModel(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingListHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.serializedPurchases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
