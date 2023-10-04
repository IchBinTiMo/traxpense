// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:traxpense/components/expense_tile.dart';
import 'package:traxpense/components/my_datepicker.dart';
import 'package:traxpense/components/my_dropdownbutton.dart';
import 'package:traxpense/components/my_piechart.dart';
import 'package:traxpense/data/expense_data.dart';
import 'package:traxpense/data/theme_provider.dart';
// import 'package:traxpense/helpers/daily_expense.dart';
// import 'package:traxpense/helpers/datename_helper.dart';
import 'package:traxpense/helpers/expense_item.dart';
// import 'package:radial_button/widget/circle_floating_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:traxpense/theme/theme.dart';
// import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpNameController = TextEditingController();
  final newExpAmountController = TextEditingController();

  final selectedTypeController = ValueNotifier("Food");

  final selectedYearController = ValueNotifier(DateTime.now().year);
  final selectedMonthController = ValueNotifier(DateTime.now().month);
  final selectedDayController = ValueNotifier(DateTime.now().day);

  DateTime selectedDate = DateTime.now();
  DateTimeRange? selectedDateRange;

  final Stream<DateTime> dateStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (count) => DateTime.now(),
  );

  @override
  void initState() {
    // Provider.of<ExpenseData>(context, listen: false)
    //     .allExpenseList
    //     .insert(0, emptyItem);
    // Provider.of<ExpenseData>(context, listen: false).initDailyExps();
    super.initState();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: const SizedBox(
                height: 20,
                child: Text("Add New Expense"),
              ),
              content: SizedBox(
                // height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // expense name
                    SizedBox(
                      height: 20,
                      child: TextField(
                        controller: newExpNameController,
                        decoration: const InputDecoration(
                          hintText: "Expense Name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // expense amount
                    TextField(
                      controller: newExpAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Expense amount",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    MyDropdownButton(items: const [
                      // "",
                      "Food",
                      "Clothing",
                      "Housing",
                      "Transportation",
                      "Education",
                      "Entertainment",
                      "Health",
                      "Others"
                    ], selectedItem: selectedTypeController),
                    MyDatePicker(
                      selectedYear: selectedYearController,
                      selectedMonth: selectedMonthController,
                      selectedDay: selectedDayController,
                    ),
                    // SizedBox(
                    //   width: 50,
                    //   child: CupertinoPicker(
                    //     itemExtent: 20,
                    //     onSelectedItemChanged: (index) {},
                    //     children: [1, 2, 3, 4, 5, 2023]
                    //         .map((e) => Text(
                    //               e.toString(),
                    //             ))
                    //         .toList(),
                    //   ),
                    // )
                    // CupertinoDatePicker(onDateTimeChanged: onDateTimeChanged)
                  ],
                ),
              ),
              actions: [
                // save button
                MaterialButton(onPressed: save, child: const Text("Save")),
                // cancel button
                MaterialButton(onPressed: cancel, child: const Text("Cancel"))
              ]);
        });
  }

  void save() {
    var logger = Logger();
    logger.d([
      selectedYearController.value,
      selectedMonthController.value,
      selectedDayController.value
    ]);
    // validate
    if (newExpNameController.text.isEmpty ||
        newExpAmountController.text.isEmpty ||
        selectedTypeController.value == "") {
      return;
    }
    // create new expense
    ExpenseItem expenseItem = ExpenseItem(
      type: selectedTypeController.value,
      name: newExpNameController.text,
      amount: newExpAmountController.text,
      dateTime: DateTime(
        selectedYearController.value,
        selectedMonthController.value,
        selectedDayController.value,
      ),
    );
    // add new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(expenseItem);
    // close dialog
    Navigator.of(context).pop();
    // clear text fields
    selectedTypeController.value = "Food";
    newExpNameController.clear();
    newExpAmountController.clear();
  }

  void cancel() {
    // close dialog
    Navigator.of(context).pop();
    // clear text fields
    selectedTypeController.value = "Food";
    newExpNameController.clear();
    newExpAmountController.clear();
  }

  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  String getWeekday(int day) {
    String weekday = "";
    switch (day) {
      case 1:
        weekday = "Monday";
      case 2:
        weekday = "Tuesday";
      case 3:
        weekday = "Wednesday";
      case 4:
        weekday = "Thursday";
      case 5:
        weekday = "Friday";
      case 6:
        weekday = "Saturday";
      case 7:
        weekday = "Sunday";
      default:
        weekday = "";
    }

    return weekday.substring(0, 3).toUpperCase();
  }

  ListView getExpenseListView(ExpenseData expenseData) {
    String range = "Daily";
    if (range != "Range") {
      // var logger = Logger();
      // logger.d(selectedDate);
      expenseData.getRequestExpenses("Daily", selectedDate, null);
    }

    List<ExpenseItem> expsFromRes = expenseData.getCurrentExpenseList();

    return ListView.builder(
        itemCount: expsFromRes.length,
        itemBuilder: (context, index) {
          return ExpenseTile(
            expIndex: index + 1,
            expLength: expsFromRes.length,
            type: expenseData.getIcon(expsFromRes[index].type),
            name: expsFromRes[index].name,
            amount: expsFromRes[index].amount,
            datetime: expsFromRes[index].dateTime,
            addExpense: (p0) => addNewExpense(),
            deleteExpense: (p0) => deleteExpense(expsFromRes[index]),
          );
        });
  }

  // Future<void> _selectDateRange(BuildContext context) async {
  //   // final DateTimeRange? pickedDateRange = await showDateRangePicker(
  //   //   context: context,
  //   //   firstDate: DateTime(2000),
  //   //   lastDate: DateTime(2100),
  //   // );

  //   // if (pickedDateRange != null && pickedDateRange != selectedDateRange) {
  //   //   setState(() {
  //   //     selectedDateRange = pickedDateRange;
  //   //   });
  //   // }
  // }
  void _selectDateRange(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: const SizedBox(
                height: 40,
                child: Text("Select Date Range"),
              ),
              content: SizedBox(
                // height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Start Date: "),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 12)),
                    MyDatePicker(
                      selectedYear: selectedYearController,
                      selectedMonth: selectedMonthController,
                      selectedDay: selectedDayController,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("End Date: "),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 12)),
                    MyDatePicker(
                      selectedYear: selectedYearController,
                      selectedMonth: selectedMonthController,
                      selectedDay: selectedDayController,
                    ),
                    // SizedBox(
                    //   width: 50,
                    //   child: CupertinoPicker(
                    //     itemExtent: 20,
                    //     onSelectedItemChanged: (index) {},
                    //     children: [1, 2, 3, 4, 5, 2023]
                    //         .map((e) => Text(
                    //               e.toString(),
                    //             ))
                    //         .toList(),
                    //   ),
                    // )
                    // CupertinoDatePicker(onDateTimeChanged: onDateTimeChanged)
                  ],
                ),
              ),
              actions: [
                // save button
                MaterialButton(onPressed: save, child: const Text("Save")),
                // cancel button
                MaterialButton(onPressed: cancel, child: const Text("Cancel"))
              ]);
        });
    // final DateTimeRange? pickedDateRange = await showDateRangePicker(
    //   context: context,
    //   firstDate: DateTime(2000),
    //   lastDate: DateTime(2100),
    // );

    // if (pickedDateRange != null && pickedDateRange != selectedDateRange) {
    //   setState(() {
    //     selectedDateRange = pickedDateRange;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(builder: (context, expenseData, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: SpeedDial(
          overlayOpacity: 0.5,
          overlayColor: Theme.of(context).colorScheme.primary,
          icon: Icons.settings,
          activeIcon: Icons.close,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.background,
          children: [
            SpeedDialChild(
              foregroundColor: Theme.of(context).colorScheme.background,
              onTap: addNewExpense,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            ),
            SpeedDialChild(
              foregroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              child: Provider.of<ThemeProvider>(context, listen: false)
                          .themeData !=
                      darkMode
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.sunny),
            ),
            SpeedDialChild(
              foregroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                _selectDateRange(context);
              },
              child: const Icon(Icons.tiktok),
            ),
          ],
        ),
        //     CircleFloatingButton.floatingActionButton(
        //   items: [
        //     FloatingActionButton(
        //       foregroundColor: Theme.of(context).colorScheme.background,
        //       onPressed: addNewExpense,
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       child: const Icon(Icons.add),
        //     ),
        //     FloatingActionButton(
        //       foregroundColor: Theme.of(context).colorScheme.background,
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       onPressed: () {},
        //       child: const Icon(Icons.sunny),
        //     ),
        //     FloatingActionButton(
        //       foregroundColor: Theme.of(context).colorScheme.background,
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       onPressed: () {},
        //       child: const Icon(Icons.sunny),
        //     )
        //   ],
        //   duration: const Duration(milliseconds: 200),
        //   icon: Icons.settings,
        //   color: Theme.of(context).colorScheme.primary,
        //   curveAnim: Curves.ease,
        //   useOpacity: false,
        // ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                        // selectedDayController.value--;
                        setState(() {
                          selectedDate =
                              selectedDate.subtract(const Duration(days: 1));
                          selectedYearController.value = selectedDate.year;
                          selectedMonthController.value = selectedDate.month;
                          selectedDayController.value = selectedDate.day;
                        });
                        // selectedDate =
                        //     selectedDate.subtract(const Duration(days: 1));
                        // var logger = Logger();
                        // logger.d(selectedDayController.value);
                      },
                      child: const Icon(Icons.keyboard_arrow_left)),
                ),
                SizedBox(
                  // height: 40,
                  width: 200,
                  child: Center(
                    child: Padding(
                      // padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "  ${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}  ${getWeekday(selectedDate.weekday)}  ",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                        // selectedDayController.value--;
                        setState(() {
                          selectedDate =
                              selectedDate.add(const Duration(days: 1));
                          selectedYearController.value = selectedDate.year;
                          selectedMonthController.value = selectedDate.month;
                          selectedDayController.value = selectedDate.day;
                        });
                        // selectedDate =
                        //     selectedDate.subtract(const Duration(days: 1));
                        // var logger = Logger();
                        // logger.d(selectedDayController.value);
                      },
                      child: const Icon(Icons.keyboard_arrow_right)),
                ),
              ],
            ),
            SizedBox(
              height: 320,
              child: MyPieChart(
                  totalAmount: expenseData.calculateTotalExpense(),
                  chartSections: expenseData.getChartSections()),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: MediaQuery.of(context).size.height - 470,
              child: getExpenseListView(expenseData),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: TextButton(
                      onPressed: () {
                        // selectedDayController.value--;
                        setState(() {
                          selectedDate =
                              selectedDate.subtract(const Duration(days: 1));
                          selectedYearController.value = selectedDate.year;
                          selectedMonthController.value = selectedDate.month;
                          selectedDayController.value = selectedDate.day;
                        });
                        // selectedDate =
                        //     selectedDate.subtract(const Duration(days: 1));
                        // var logger = Logger();
                        // logger.d(selectedDayController.value);
                      },
                      child: const Icon(Icons.keyboard_arrow_left)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: TextButton(
                      onPressed: () {
                        // selectedDayController.value--;
                        setState(() {
                          selectedDate =
                              selectedDate.add(const Duration(days: 1));
                          selectedYearController.value = selectedDate.year;
                          selectedMonthController.value = selectedDate.month;
                          selectedDayController.value = selectedDate.day;
                        });
                        // selectedDate =
                        //     selectedDate.subtract(const Duration(days: 1));
                        // var logger = Logger();
                        // logger.d(selectedDayController.value);
                      },
                      child: const Icon(Icons.keyboard_arrow_right)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
