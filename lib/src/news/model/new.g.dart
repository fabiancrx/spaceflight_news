// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewAdapter extends TypeAdapter<New> {
  @override
  final int typeId = 1;

  @override
  New read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return New(
      id: fields[0] as int,
      featured: fields[1] as bool,
      title: fields[2] as String,
      url: fields[3] as String,
      imageUrl: fields[4] as String,
      newsSite: fields[5] as String,
      summary: fields[6] as String,
      publishedAt: fields[7] as DateTime,
      isFavorite: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, New obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.featured)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.newsSite)
      ..writeByte(6)
      ..write(obj.summary)
      ..writeByte(7)
      ..write(obj.publishedAt)
      ..writeByte(8)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
