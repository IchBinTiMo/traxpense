import 'package:traxpense/helpers/expense_item.dart';

class DailyExpense {
  final DateTime date;
  final Map<String, double> summary;
  final List<ExpenseItem> expItems;

  DailyExpense({
    required this.date,
    required this.summary,
    required this.expItems,
  });
}
