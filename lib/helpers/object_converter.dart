import 'package:traxpense/helpers/daily_expense.dart';
import 'package:traxpense/helpers/expense_item.dart';

class ObjectConverter {
  // expense item to map
  Map<String, dynamic> expenseItemToMap(ExpenseItem expenseItem) {
    return {
      "type": expenseItem.type,
      "name": expenseItem.name,
      "amount": expenseItem.amount,
      "dateTime": expenseItem.dateTime?.toString()
    };
  }

  // map to expense item
  ExpenseItem mapToExpenseItem(Map<String, dynamic> map) {
    return ExpenseItem(
      type: map["type"],
      name: map["name"],
      amount: map["amount"],
      dateTime: DateTime.parse(
        map["dateTime"],
      ),
    );
  }

  // maps to expense items
  List<ExpenseItem> mapsListToExpenseItemsList(
      List<Map<String, dynamic>> maps) {
    return maps.map((map) => mapToExpenseItem(map)).toList();
  }

  // expense items to maps
  List<Map<String, dynamic>> expenseItemListsToMapsList(
      List<ExpenseItem> expenseItems) {
    return expenseItems
        .map((expenseItem) => expenseItemToMap(expenseItem))
        .toList();
  }

  // daily expense to map
  Map<String, dynamic> dailyExpenseToMap(DailyExpense dailyExpense) {
    return {
      "date": dailyExpense.date.toString().split(" ")[0],
      "summary": dailyExpense.summary,
      "expItems": expenseItemListsToMapsList(dailyExpense.expItems),
    };
  }

  // map to daily expense
  DailyExpense mapToDailyExpense(Map<String, dynamic> map) {
    Map<String, double> summary = {};
    List<Map<String, dynamic>> expItems = [];

    for (String key in map["summary"].keys) {
      summary[key] = map["summary"][key];
    }
    for (Map<String, dynamic> value in map["expItems"]) {
      expItems.add(value);
    }
    return DailyExpense(
      date: DateTime.parse(map["date"]),
      summary: summary,
      expItems: mapsListToExpenseItemsList(expItems),
    );
  }

  // daiily expenses to a firestore map
  Map<String, dynamic> dailyExpensesToFireStoreMap(
      Map<DateTime, DailyExpense> dailyExpenses) {
    return dailyExpenses.map((key, value) =>
        MapEntry(key.toString().split(" ")[0], dailyExpenseToMap(value)));
  }

  // a firestore map to daily expenses
  Map<DateTime, DailyExpense> fireStoreMapToDailyExpenses(
      Map<String, dynamic> map) {
    return map.map((key, value) {
      return MapEntry(DateTime.parse(key), mapToDailyExpense(value));
    });
  }
}
