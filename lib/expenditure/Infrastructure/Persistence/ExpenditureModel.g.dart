// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExpenditureModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenditureHiveModelAdapter extends TypeAdapter<ExpenditureHiveModel> {
  @override
  final int typeId = 1;

  @override
  ExpenditureHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenditureHiveModel(
      name: fields[0] as String,
      type: fields[1] as int,
      amount: fields[2] as int,
      cardType: fields[3] as String?,
      expenditureType: fields[4] as int?,
      currentInstallment: fields[5] as int?,
      totalInstallment: fields[6] as int?
    );
  }

  @override
  void write(BinaryWriter writer, ExpenditureHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.cardType)
      ..writeByte(4)
      ..write(obj.expenditureType)
      ..writeByte(5)
      ..write(obj.currentInstallment)
      ..writeByte(6)
      ..write(obj.totalInstallment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenditureHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
