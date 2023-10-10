import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:traxpense/components/indicator.dart';
import 'package:traxpense/data/database.dart';
import 'package:traxpense/helpers/daily_expense.dart';
import 'package:traxpense/helpers/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  ExpenseItem emptyItem = ExpenseItem(
    type: '',
    name: '',
    amount: '',
    dateTime: null,
  );

  List<ExpenseItem> allExpenseList = [];

  List<ExpenseItem> currentExpenseList = [];

  Map<DateTime, DailyExpense> dailyExps = {};

  List<DailyExpense> ret = [];

  Map<String, double> summarySortByType = {};

  PieChart chartSections = PieChart(
    PieChartData(
      centerSpaceRadius: 10,
      sections: [],
    ),
  );

  final Map<String, Color> colorList = {
    "Food": const Color.fromARGB(166, 244, 67, 54),
    "Clothing": const Color.fromARGB(166, 255, 153, 0),
    "Housing": const Color.fromARGB(166, 255, 235, 59),
    "Transportation": const Color.fromARGB(166, 76, 175, 79),
    "Entertainment": const Color.fromARGB(166, 33, 149, 243),
    "Education": const Color.fromARGB(166, 63, 81, 181),
    "Health": const Color.fromARGB(166, 155, 39, 176),
    "Others": const Color.fromARGB(166, 85, 110, 130)
  };

  List<ExpenseItem> getCurrentExpenseList() {
    return currentExpenseList;
  }

  Map<String, double> getSummarySortByType() {
    return summarySortByType;
  }

  PieChart getChartSections() {
    return chartSections;
  }

  void loadDataFromDB(ExpensesDataBase db) {
    dailyExps = db.allExps;
  }

  List<DateTime> getAllEventDates() {
    return dailyExps.keys.toList();
    // .where((element) => dailyExps[element]!.expItems.isNotEmpty)
    // .toList();
  }

  void getRequestExpenses(
      String range, DateTime startDate, DateTime? endDate, bool isPercentage) {
    ret.clear();
    summarySortByType = {
      "Food": 0,
      "Clothing": 0,
      "Housing": 0,
      "Transportation": 0,
      "Entertainment": 0,
      "Education": 0,
      "Health": 0,
      "Others": 0
    };
    DateTime start;
    DateTime end;

    switch (range) {
      case "Daily":
        start = DateTime(startDate.year, startDate.month, startDate.day)
            .subtract(const Duration(milliseconds: 1));
        end = DateTime(startDate.year, startDate.month, startDate.day)
            .add(const Duration(days: 1));
        break;
      case "Weekly":
        start = startOfTheWeek(
                DateTime(startDate.year, startDate.month, startDate.day))
            .subtract(const Duration(milliseconds: 1));
        end = start
            .add(const Duration(days: 7))
            .add(const Duration(milliseconds: 1));
        break;
      case "Monthly":
        start = DateTime(startDate.year, startDate.month)
            .subtract(const Duration(milliseconds: 1));
        end = DateTime(start.year, start.month + 2);
        break;
      case "Yearly":
        start =
            DateTime(startDate.year).subtract(const Duration(milliseconds: 1));
        end = DateTime(start.year + 2);
        break;
      case "Custom":
        start = startDate.subtract(const Duration(milliseconds: 1));
        end = endDate!.add(const Duration(days: 1));
      default:
        start = startDate.subtract(const Duration(milliseconds: 1));
        end = startDate.add(const Duration(days: 1));
    }

    if (range != "Overall") {
      for (var date in dailyExps.keys) {
        if (date.isAfter(start) && date.isBefore(end)) {
          ret.addAll([dailyExps[date]!]);
        }
      }
    } else {
      ret.addAll(dailyExps.values);
    }

    ret.sort((a, b) => b.date.compareTo(a.date));

    currentExpenseList.clear();

    for (var day in ret) {
      currentExpenseList.addAll(day.expItems);
    }

    for (var exp in currentExpenseList) {
      String type = exp.type;
      if (type == '') {
        continue;
      }

      double amount = (exp.amount != "") ? double.parse(exp.amount) : 0.0;

      if (summarySortByType.containsKey(type)) {
        double current = summarySortByType[type]!;
        current += amount;
        summarySortByType[type] = current;
      } else {
        summarySortByType.addAll({type: amount});
      }
    }

    currentExpenseList.insert(0, emptyItem);
    chartSections = calculateChartSections(isPercentage);
  }

  void initDailyExps() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    var day = DateTime.now().day;
    if (dailyExps.containsKey(DateTime(year, month, day)) == false) {
      dailyExps[DateTime(year, month, day)] = DailyExpense(
        date: DateTime(year, month, day),
        summary: {},
        expItems: [emptyItem],
      );
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem expenseItem, ExpensesDataBase db) {
    DateTime key = DateTime(expenseItem.dateTime!.year,
        expenseItem.dateTime!.month, expenseItem.dateTime!.day);

    if (dailyExps.containsKey(key)) {
      dailyExps[key]!.expItems.insert(0, expenseItem);
      dailyExps[key]!.summary[expenseItem.type] =
          double.parse(expenseItem.amount);
    } else {
      dailyExps[key] = DailyExpense(
        date: key,
        summary: {
          "Food": 0,
          "Clothing": 0,
          "Housing": 0,
          "Transportation": 0,
          "Entertainment": 0,
          "Education": 0,
          "Health": 0,
          "Others": 0
        },
        expItems: [],
      );
      dailyExps[key]!.expItems.insert(0, expenseItem);
      dailyExps[key]!.summary[expenseItem.type] =
          double.parse(expenseItem.amount);
    }
    notifyListeners();
    db.allExps = dailyExps;
    db.updateExpenses();
  }

  // delete expense
  void deleteExpense(ExpenseItem expenseItem, ExpensesDataBase db) {
    DateTime key = DateTime(expenseItem.dateTime!.year,
        expenseItem.dateTime!.month, expenseItem.dateTime!.day);
    dailyExps[key]!.expItems.remove(expenseItem);
    if (dailyExps[key]!.expItems.isEmpty) {
      dailyExps.remove(key);
    }
    currentExpenseList.remove(expenseItem);
    notifyListeners();
    db.allExps = dailyExps;
    db.updateExpenses();
  }

  // get start of the week
  DateTime startOfTheWeek(DateTime today) {
    DateTime? startOfWeek;

    for (int i = 0; i < 7; i++) {
      if (today.subtract(Duration(days: i)).weekday == 7) {
        startOfWeek = today.subtract(Duration(days: i));
        break;
      }
    }

    return startOfWeek!;
  }

  double calculateTotalExpense() {
    double totalExpense = 0.0;
    for (var type in [
      "Food",
      "Clothing",
      "Housing",
      "Transportation",
      "Entertainment",
      "Health",
      "Education",
      "Others"
    ]) {
      if (summarySortByType.containsKey(type)) {
        totalExpense += summarySortByType[type]!;
      } else {
        totalExpense += 0.0;
      }
    }

    return totalExpense;
  }

  // get icons for type of expense
  Icon? getIcon(String type) {
    switch (type) {
      case 'Food':
        return const Icon(
          Icons.fastfood,
          size: 35,
        );
      case 'Clothing':
        return const Icon(
          Icons.checkroom,
          size: 35,
        );
      case 'Housing':
        return const Icon(
          Icons.home,
          size: 35,
        );
      case 'Transportation':
        return const Icon(
          Icons.directions_bus,
          size: 35,
        );
      case 'Education':
        return const Icon(
          Icons.school,
          size: 35,
        );
      case 'Entertainment':
        return const Icon(
          Icons.movie,
          size: 35,
        );
      case 'Health':
        return const Icon(
          Icons.health_and_safety,
          size: 35,
        );
      case 'Others':
        return const Icon(
          Icons.more_horiz,
          size: 35,
        );
      case '':
        return null;
      default:
        return const Icon(
          Icons.more_horiz,
          size: 35,
        );
    }
  }

  List<Indicator> getIndicators() {
    List<Indicator> indicators = [];
    for (var type in [
      "Food",
      "Clothing",
      "Housing",
      "Transportation",
      "Entertainment",
      "Education",
      "Health",
      "Others"
    ]) {
      if (getSummarySortByType()[type]! > 0.0) {
        indicators.add(Indicator(
          color: colorList[type]!,
          text: type,
          size: 20,
          isSquare: false,
        ));
      }
    }

    return indicators;
  }

  PieChart calculateChartSections(bool isPercentage) {
    List<PieChartSectionData> chartSections = [];
    num total = calculateTotalExpense();
    for (var type in [
      "Food",
      "Clothing",
      "Housing",
      "Transportation",
      "Entertainment",
      "Health",
      "Education",
      "Others"
    ]) {
      if (getSummarySortByType().containsKey(type)) {
        num tmp = ((getSummarySortByType()[type] ?? 0) /
                (total > 0 ? total : 1) *
                1000)
            .round();
        chartSections.add(PieChartSectionData(
            color: colorList[type]!,
            value: isPercentage
                ? (getSummarySortByType()[type] ?? 0) /
                    (total > 0 ? total : 1) *
                    100
                : getSummarySortByType()[type] ?? 0,
            title: isPercentage
                ? "${(tmp / 10) % 1 == 0 ? tmp ~/ 10 : (tmp / 10)}%"
                : (getSummarySortByType()[type] ?? 0) % 1 == 0
                    ? (getSummarySortByType()[type] ?? 0).toInt().toString()
                    : getSummarySortByType()[type]?.toString(),
            radius: 110,
            titleStyle: const TextStyle(
              fontSize: 20,
            )));
      }
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 3.5,
        centerSpaceRadius: 10,
        sections: chartSections,
      ),
    );
  }
}
