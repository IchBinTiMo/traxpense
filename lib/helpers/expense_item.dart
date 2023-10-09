import 'package:hive_flutter/hive_flutter.dart';
part 'expense_item.g.dart';

@HiveType(typeId: 0)
class ExpenseItem extends HiveObject {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String amount;
  @HiveField(3)
  final DateTime? dateTime;

  ExpenseItem(
      {required this.type,
      required this.name,
      required this.amount,
      required this.dateTime});
}

// class ExpenseItemAdapter extends TypeAdapter<ExpenseItem> {
//   @override
//   final typeId = 0;

//   @override
//   ExpenseItem read(BinaryReader reader) {
//     return ExpenseItem(
//       type: reader.readString(),
//       name: reader.readString(),
//       amount: reader.readString(),
//       dateTime: reader.read(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, ExpenseItem obj) {
//     writer.write(obj);
//   }
// }
