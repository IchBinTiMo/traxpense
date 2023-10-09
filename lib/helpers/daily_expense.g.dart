// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyExpenseAdapter extends TypeAdapter<DailyExpense> {
  @override
  final int typeId = 1;

  @override
  DailyExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyExpense(
      date: fields[0] as DateTime,
      summary: (fields[1] as Map).cast<String, double>(),
      expItems: (fields[2] as List).cast<ExpenseItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyExpense obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.expItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
