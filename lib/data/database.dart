// import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:traxpense/helpers/daily_expense.dart';
// import 'package:traxpense/helpers/expense_item.dart';
// import 'package:traxpense/theme/theme.dart';

class ExpensesDataBase {
  // reference to the box
  final _myBox = Hive.box('expense_db');

  Map<DateTime, DailyExpense> allExps = {};
  String themeNow = "light";

  // ExpensesDataBase() {
  //   createInitialData();
  // }

  void createInitialData() {
    // allExps = {};
    themeNow = "light";
    _myBox.put("theme", themeNow);
  }

  // load the data from database
  void loadData() {
    allExps = Map<DateTime, DailyExpense>.from(_myBox.get("expensesByDay"));
    themeNow = _myBox.get("theme");
    // var logger = Logger();
    // logger.d(themeNow);
  }

  // update the database
  void updateExpenses() {
    _myBox.put("expensesByDay", allExps);
  }

  // update the theme
  void updateTheme() {
    var logger = Logger();
    logger.d(themeNow);
    _myBox.put("theme", themeNow);
  }
}
