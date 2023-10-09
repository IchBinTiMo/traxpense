// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseItemAdapter extends TypeAdapter<ExpenseItem> {
  @override
  final int typeId = 0;

  @override
  ExpenseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseItem(
      type: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as String,
      dateTime: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
