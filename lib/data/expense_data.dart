import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:traxpense/components/indicator.dart';
import 'package:traxpense/helpers/daily_expense.dart';
// import 'package:traxpense/helpers/datename_helper.dart';
import 'package:traxpense/helpers/expense_item.dart';
import 'package:logger/logger.dart';

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

  // final Map<String, Color> colorList = {
  //   "Food": const Color.fromARGB(255, 248, 132, 124),
  //   "Clothing": const Color.fromARGB(255, 255, 189, 89),
  //   "Housing": const Color.fromARGB(255, 255, 242, 127),
  //   "Transportation": const Color.fromARGB(255, 138, 203, 140),
  //   "Entertainment": const Color.fromARGB(255, 110, 186, 247),
  //   "Health": const Color.fromARGB(255, 130, 142, 207),
  //   "Education": const Color.fromARGB(255, 190, 114, 204),
  //   "Others": const Color.fromARGB(255, 89, 144, 126)
  // };

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

  // final Map<String, Color> colorList = {
  //   "Food": Colors.red.shade300,
  //   "Clothing": Colors.orange.shade300,
  //   "Housing": Colors.yellow.shade300,
  //   "Transportation": Colors.green.shade300,
  //   "Entertainment": Colors.blue.shade300,
  //   "Health": Colors.indigo.shade300,
  //   "Education": Colors.purple.shade300,
  //   "Others": Colors.blueGrey.shade300
  // };

  List<ExpenseItem> getCurrentExpenseList() {
    return currentExpenseList;
  }

  Map<String, double> getSummarySortByType() {
    return summarySortByType;
  }

  PieChart getChartSections() {
    return chartSections;
  }

  void getRequestExpenses(String range, DateTime startDate, DateTime? endDate) {
    // initDailyExps();

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
    // DateTime today =
    //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
    var logger = Logger();
    logger.d([start, end]);

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
        // dailyExpenseSum[type] = current;
        summarySortByType[type] = current;
      } else {
        summarySortByType.addAll({type: amount});
      }
    }

    // logger.d(summarySortByType);

    currentExpenseList.insert(0, emptyItem);
    chartSections = calculateChartSections();
    // for (var exp in allExpenseList) {
    //   String type = exp.type;
    //   if (type == '') {
    //     continue;
    //   }
    //   // String date = converDateTimeToString(exp.dateTime);
    //   double amount = (exp.amount != "") ? double.parse(exp.amount) : 0.0;

    //   if (dailyExpenseSum.containsKey(type)) {
    //     double current = dailyExpenseSum[type]!;
    //     current += amount;
    //     dailyExpenseSum[type] = current;
    //   } else {
    //     dailyExpenseSum.addAll({type: amount});
    //   }
    // }
  }

  // List<ExpenseItem> getAllExpenseList() {
  //   // initDailyExps();
  //   // List<ExpenseItem> ret = [];
  //   // for (var date in dailyExps.keys) {
  //   //   ret.addAll([dailyExps[date]!.expItems]);
  //   // }
  //   // return ret;
  //   return allExpenseList;
  // }

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
  void addNewExpense(ExpenseItem expenseItem) {
    DateTime key = DateTime(expenseItem.dateTime!.year,
        expenseItem.dateTime!.month, expenseItem.dateTime!.day);

    // List<ExpenseItem> exps;

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
    // if (getCurrentExpenseList().isNotEmpty) {
    //   allExpenseList.remove(getCurrentExpenseList()[0]);
    // }
    // allExpenseList.insert(0, expenseItem);
    // allExpenseList.insert(0, emptyItem);
    notifyListeners();
  }

  // delete expense
  void deleteExpense(ExpenseItem expenseItem) {
    DateTime key = DateTime(expenseItem.dateTime!.year,
        expenseItem.dateTime!.month, expenseItem.dateTime!.day);
    dailyExps[key]!.expItems.remove(expenseItem);
    currentExpenseList.remove(expenseItem);
    notifyListeners();
  }

  // get day name
  // String getDayName(DateTime dateTime) {
  //   switch (dateTime.weekday) {
  //     case 0:
  //       return 'Sun';
  //     case 1:
  //       return 'Mon';
  //     case 2:
  //       return 'Tue';
  //     case 3:
  //       return 'Wed';
  //     case 4:
  //       return 'Thu';
  //     case 5:
  //       return 'Fri';
  //     case 6:
  //       return 'Sat';
  //     default:
  //       return '';
  //   }
  // }

  // get start of the week
  DateTime startOfTheWeek(DateTime today) {
    DateTime? startOfWeek;

    // DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (today.subtract(Duration(days: i)).weekday == 7) {
        startOfWeek = today.subtract(Duration(days: i));
        break;
      }
    }

    return startOfWeek!;
  }

  // calculate daily expense
  // Map<String, double> calculateDailyExpenseSum() {
  // double sum = 0.0;
  // for (var key in summarySortByType.keys) {
  //   sum += summarySortByType[key]!;
  // }
  // return sum;
  // Map<String, double> dailyExpenseSum = {};

  // for (var exp in allExpenseList) {
  //   String type = exp.type;
  //   if (type == '') {
  //     continue;
  //   }
  //   // String date = converDateTimeToString(exp.dateTime);
  //   double amount = (exp.amount != "") ? double.parse(exp.amount) : 0.0;

  //   if (dailyExpenseSum.containsKey(type)) {
  //     double current = dailyExpenseSum[type]!;
  //     current += amount;
  //     dailyExpenseSum[type] = current;
  //   } else {
  //     dailyExpenseSum.addAll({type: amount});
  //   }
  // }

  // return dailyExpenseSum;
  // }

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
      // if (calculateDailyExpenseSum().containsKey(type)) {
      //   totalExpense += calculateDailyExpenseSum()[type]!;
      // }
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
    // var logger = Logger();
    // logger.d(getSummarySortByType());
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
      // logger.d(type);
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

  PieChart calculateChartSections() {
    // var logger = Logger();
    // logger.d(getSummarySortByType());
    List<PieChartSectionData> chartSections = [];
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
        chartSections.add(PieChartSectionData(
          color: colorList[type]!,
          value: getSummarySortByType()[type] ?? 0,
          radius: 110,
        ));
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
