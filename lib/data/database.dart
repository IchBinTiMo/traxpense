import 'package:hive_flutter/hive_flutter.dart';
import 'package:traxpense/helpers/daily_expense.dart';

class ExpensesDataBase {
  // reference to the box
  final _myBox = Hive.box('expense_db');

  Map<DateTime, DailyExpense> allExps = {};
  String themeNow = "light";

  void createInitialData() {
    themeNow = "light";
    _myBox.put("theme", themeNow);
  }

  // load the data from database
  void loadData() {
    if (_myBox.get("expensesByDay") != null) {
      allExps = Map<DateTime, DailyExpense>.from(_myBox.get("expensesByDay"));
    }
    if (_myBox.get("theme") != null) {
      themeNow = _myBox.get("theme");
    }
  }

  // update the database
  void updateExpenses() {
    _myBox.put("expensesByDay", allExps);
  }

  // update the theme
  void updateTheme() {
    _myBox.put("theme", themeNow);
  }
}
