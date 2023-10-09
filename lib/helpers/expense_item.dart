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
