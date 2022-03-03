// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookHiveModelAdapter extends TypeAdapter<BookHiveModel> {
  @override
  final int typeId = 4;

  @override
  BookHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookHiveModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.chapter)
      ..writeByte(3)
      ..write(obj.ignoreUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
