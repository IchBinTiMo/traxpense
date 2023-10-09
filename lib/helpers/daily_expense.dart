import 'package:hive_flutter/hive_flutter.dart';
import 'package:traxpense/helpers/expense_item.dart';
part 'daily_expense.g.dart';

@HiveType(typeId: 1)
class DailyExpense {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final Map<String, double> summary;
  @HiveField(2)
  final List<ExpenseItem> expItems;

  DailyExpense({
    required this.date,
    required this.summary,
    required this.expItems,
  });
}
