// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodLogEntryAdapter extends TypeAdapter<FoodLogEntry> {
  @override
  final int typeId = 3;

  @override
  FoodLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodLogEntry(
      id: fields[0] as String,
      mealName: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      healthScore: fields[3] as int,
      aiAnalysis: fields[4] as String,
      date: fields[5] as DateTime?,
      tags: (fields[6] as List).cast<String>(),
      isFavourite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FoodLogEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mealName)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.healthScore)
      ..writeByte(4)
      ..write(obj.aiAnalysis)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isFavourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
