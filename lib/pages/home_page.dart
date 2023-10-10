import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:traxpense/components/dialog_box.dart';
import 'package:traxpense/components/expense_tile.dart';
// import 'package:traxpense/components/my_datepicker.dart';
import 'package:traxpense/components/my_dropdownbutton.dart';
import 'package:traxpense/components/my_piechart.dart';
import 'package:traxpense/data/expense_data.dart';
import 'package:traxpense/data/database.dart';
import 'package:traxpense/data/theme_provider.dart';
import 'package:traxpense/helpers/expense_item.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:traxpense/theme/theme.dart';

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

  final selectedRangeTypeController = ValueNotifier("Daily");

  final startYearController = ValueNotifier(DateTime.now().year);
  final startMonthController = ValueNotifier(DateTime.now().month);
  final startDayController = ValueNotifier(DateTime.now().day);

  final endYearController = ValueNotifier(DateTime.now().year);
  final endMonthController = ValueNotifier(DateTime.now().month);
  final endDayController = ValueNotifier(DateTime.now().day);

  final gotoDateController = DateRangePickerController();

  final selectedDateController = DateRangePickerController();

  DateTime selectedDate = DateTime.now();
  DateTimeRange? selectedDateRange;
  // String selectedDateString = "";

  String rangeType = "Daily";

  bool isPercentage = false;

  DateTime startForRange = DateTime.now();
  DateTime endForRange = DateTime.now();

  final _myBox = Hive.box("expense_db");
  ExpensesDataBase db = ExpensesDataBase();

  @override
  void initState() {
    if (_myBox.get("expensesByDay") != null) {
      db.loadData();
      Provider.of<ExpenseData>(context, listen: false).loadDataFromDB(db);
      Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);
    } else {
      db.createInitialData();
    }
    selectedDateController.selectedDate = DateTime.now();
    // selectedDateString =
    //     "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}";
    super.initState();
  }

  void addNewExpense() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return DialogBox(
    //         newExpNameController: newExpNameController,
    //         newExpAmountController: newExpAmountController,
    //         selectedTypeController: selectedTypeController,
    //         selectedDateController: selectedDateController,
    //         allEventDays: Provider.of<ExpenseData>(context, listen: false)
    //             .getAllEventDates(),
    //         save: save,
    //         cancel: cancel);
    //   },
    // );
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateInDialog) {
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
                    MaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                title: const Text("Select Date"),
                                content: SizedBox(
                                  height: 300,
                                  width: 800,
                                  child: SfDateRangePicker(
                                    initialSelectedDate: DateTime.now(),
                                    initialDisplayDate:
                                        selectedDateController.selectedDate,
                                    onSelectionChanged:
                                        (dateRangePickerSelectionChangedArgs) {
                                      setState(() {
                                        rangeType = "Daily";
                                        selectedDate =
                                            dateRangePickerSelectionChangedArgs
                                                .value;
                                        selectedYearController.value =
                                            selectedDate.year;
                                        selectedMonthController.value =
                                            selectedDate.month;
                                        selectedDayController.value =
                                            selectedDate.day;
                                        // var logger = Logger();
                                        // logger.d(selectedDate);
                                      });
                                      setStateInDialog(() {
                                        rangeType = "Daily";
                                        selectedDate =
                                            dateRangePickerSelectionChangedArgs
                                                .value;
                                        selectedYearController.value =
                                            selectedDate.year;
                                        selectedMonthController.value =
                                            selectedDate.month;
                                        selectedDayController.value =
                                            selectedDate.day;
                                      });
                                      // selectedDateString =
                                      //     "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}";
                                      // logger.d(selectedDateString);
                                      Navigator.of(context).pop();
                                    },
                                    view: DateRangePickerView.month,
                                    maxDate: DateTime.now(),
                                    todayHighlightColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                      showWeekNumber: true,
                                      specialDates: Provider.of<ExpenseData>(
                                              context,
                                              listen: false)
                                          .getAllEventDates(),
                                    ),
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                            textStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            specialDatesDecoration:
                                                BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              shape: BoxShape.circle,
                                            ),
                                            disabledDatesTextStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            )),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                          "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}"),
                    )
                    // MyDatePicker(
                    //   selectedYear: selectedYearController,
                    //   selectedMonth: selectedMonthController,
                    //   selectedDay: selectedDayController,
                    // ),
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
      },
    );
  }

  void save() {
    // var logger = Logger();
    // logger.d([
    //   selectedYearController.value,
    //   selectedMonthController.value,
    //   selectedDayController.value
    // ]);
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
    Provider.of<ExpenseData>(context, listen: false)
        .addNewExpense(expenseItem, db);

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
    Provider.of<ExpenseData>(context, listen: false)
        .deleteExpense(expenseItem, db);
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
    String rangeType = selectedRangeTypeController.value;
    if (rangeType != "Custom") {
      expenseData.getRequestExpenses(
          rangeType, selectedDate, null, isPercentage);
    } else {
      expenseData.getRequestExpenses(
          rangeType, startForRange, endForRange, isPercentage);
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

  String getTitle(ExpenseData expenseData) {
    String title = "";
    switch (rangeType) {
      case "Daily":
        title =
            "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}  ${getWeekday(selectedDate.weekday)}";
        break;
      case "Weekly":
        DateTime startOfWeek = expenseData.startOfTheWeek(selectedDate);
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
        title =
            "${startOfWeek.year} - ${startOfWeek.month} - ${startOfWeek.day} ~ ${endOfWeek.year} - ${endOfWeek.month} - ${endOfWeek.day}";
        break;
      case "Monthly":
        title = "${selectedDate.year} - ${selectedDate.month}";
        break;
      case "Yearly":
        title = "${selectedDate.year}";
        break;
      case "Overall":
        title = "Overall";
        break;
      case "Custom":
        title =
            "${startForRange.year} - ${startForRange.month} - ${startForRange.day} ~ ${endForRange.year} - ${endForRange.month} - ${endForRange.day}";
        break;
    }
    return title;
  }

  String getSelectedDate() {
    return "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}";
  }

  Future<void> _selectDateRange(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateInDialog) {
            return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: const SizedBox(
                  height: 40,
                  child: Text("Select Date Range"),
                ),
                content: SizedBox(
                  height: 300,
                  width: 800,
                  child: SfDateRangePicker(
                    // controller: gotoDateController,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedDate: DateTime.now(),
                    initialDisplayDate: selectedDate,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      // var logger = Logger();
                      // logger.d(
                      //     dateRangePickerSelectionChangedArgs.value.startDate);
                      // logger
                      //     .d(dateRangePickerSelectionChangedArgs.value.endDate);
                      final DateTime? start =
                          dateRangePickerSelectionChangedArgs.value.startDate;
                      final DateTime? end =
                          dateRangePickerSelectionChangedArgs.value.endDate;
                      setState(() {
                        if (start != null && end != null) {
                          startYearController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.startDate.year;
                          startMonthController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.startDate.month;
                          startDayController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.startDate.day;

                          endYearController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.endDate.year;
                          endMonthController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.endDate.month;
                          endDayController.value =
                              dateRangePickerSelectionChangedArgs
                                  .value.endDate.day;
                        }
                      });
                    },
                    // onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    //   var logger = Logger();
                    //   logger.d(dateRangePickerSelectionChangedArgs.value);
                    //   // logger.d(gotoDateController.selectedDates);
                    //   setState(() {
                    //     // rangeType = "Daily";
                    //     // selectedDate =
                    //     //     dateRangePickerSelectionChangedArgs.value;
                    //     // selectedYearController.value =
                    //     //     selectedDate.year;
                    //     // selectedMonthController.value =
                    //     //     selectedDate.month;
                    //     // selectedDayController.value = selectedDate.day;
                    //     startYearController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.startDate.year;
                    //     startMonthController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.startDate.month;
                    //     startDayController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.startDate.day;

                    //     endYearController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.endDate.year;
                    //     endMonthController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.endDate.month;
                    //     endDayController.value =
                    //         dateRangePickerSelectionChangedArgs
                    //             .value.endDate.day;
                    //   });
                    //   Navigator.of(context).pop();
                    // },
                    view: DateRangePickerView.month,
                    maxDate: DateTime.now(),
                    todayHighlightColor: Theme.of(context).colorScheme.tertiary,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      showWeekNumber: true,
                      specialDates:
                          Provider.of<ExpenseData>(context, listen: false)
                              .getAllEventDates(),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        specialDatesDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                          shape: BoxShape.circle,
                        ),
                        disabledDatesTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ),
                  // child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     const Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Text("Start Date: "),
                  //       ],
                  //     ),
                  //     const Padding(padding: EdgeInsets.only(bottom: 12)),
                  //     MyDatePicker(
                  //       selectedYear: startYearController,
                  //       selectedMonth: startMonthController,
                  //       selectedDay: startDayController,
                  //     ),
                  //     const Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Text("End Date: "),
                  //       ],
                  //     ),
                  //     const Padding(padding: EdgeInsets.only(bottom: 12)),
                  //     MyDatePicker(
                  //       selectedYear: endYearController,
                  //       selectedMonth: endMonthController,
                  //       selectedDay: endDayController,
                  //     ),
                  //   ],
                  // ),
                ),
                actions: [
                  // save button
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          startForRange = DateTime(
                            startYearController.value,
                            startMonthController.value,
                            startDayController.value,
                          );
                          endForRange = DateTime(
                            endYearController.value,
                            endMonthController.value,
                            endDayController.value,
                          );
                        });

                        Navigator.of(context).pop();

                        startYearController.value = DateTime.now().year;
                        startMonthController.value = DateTime.now().month;
                        startDayController.value = DateTime.now().day;

                        endYearController.value = DateTime.now().year;
                        endMonthController.value = DateTime.now().month;
                        endDayController.value = DateTime.now().day;
                      },
                      child: const Text("Save")),
                  // cancel button
                  MaterialButton(onPressed: cancel, child: const Text("Cancel"))
                ]);
          });
        });
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
                    .toggleTheme(db);
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
                setState(() {
                  isPercentage = !isPercentage;
                });
              },
              child: isPercentage
                  ? const Icon(Icons.tag)
                  : const Icon(Icons.percent),
            ),
            SpeedDialChild(
              foregroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        title: const Text("Go to"),
                        content: SizedBox(
                          height: 300,
                          width: 800,
                          child: SfDateRangePicker(
                            // controller: gotoDateController,
                            initialDisplayDate: selectedDate,
                            onSelectionChanged:
                                (dateRangePickerSelectionChangedArgs) {
                              // var logger = Logger();
                              // logger
                              //     .d(dateRangePickerSelectionChangedArgs.value);
                              // logger.d(gotoDateController.selectedDate);
                              setState(() {
                                rangeType = "Daily";
                                selectedRangeTypeController.value = rangeType;
                                selectedDate =
                                    dateRangePickerSelectionChangedArgs.value;
                                selectedYearController.value =
                                    selectedDate.year;
                                selectedMonthController.value =
                                    selectedDate.month;
                                selectedDayController.value = selectedDate.day;
                              });
                              Navigator.of(context).pop();
                            },
                            view: DateRangePickerView.month,
                            maxDate: DateTime.now(),
                            todayHighlightColor:
                                Theme.of(context).colorScheme.tertiary,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              showWeekNumber: true,
                              specialDates: Provider.of<ExpenseData>(context,
                                      listen: false)
                                  .getAllEventDates(),
                            ),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                specialDatesDecoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  shape: BoxShape.circle,
                                ),
                                disabledDatesTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                          ),
                        ),
                      );
                    });
                // final result =

                // final result = await showDatePicker(
                //   context: context,
                //   initialDate: selectedDate,
                //   firstDate: DateTime(1950),
                //   lastDate: DateTime.now(),
                //   builder: (context, child) {
                //     return Theme(
                //       data: Theme.of(context)
                //           .copyWith(colorScheme: Theme.of(context).colorScheme),
                //       child: child!,
                //     );
                //   },
                // );
                // var logger = Logger();
                // logger.d(result);
                // if (result != null) {
                //   setState(() {
                //     rangeType = "Daily";
                //     selectedDate = result;
                //     selectedYearController.value = selectedDate.year;
                //     selectedMonthController.value = selectedDate.month;
                //     selectedDayController.value = selectedDate.day;
                //   });
                // }
              },
              child: const Text("TP"),
            ),
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  // height: 40,
                  width: 250,
                  child: Center(
                    child: Padding(
                      // padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        getTitle(expenseData),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 320,
              child: MyPieChart(
                totalAmount: expenseData.calculateTotalExpense(),
                chartSections: expenseData.getChartSections(),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: MediaQuery.of(context).size.height - 470,
              child: Container(child: getExpenseListView(expenseData)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                rangeType != "Overall" && rangeType != "Custom"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (rangeType == "Daily") {
                                  selectedDate = selectedDate
                                      .subtract(const Duration(days: 1));
                                } else if (rangeType == "Weekly") {
                                  selectedDate = selectedDate
                                      .subtract(const Duration(days: 7));
                                } else if (rangeType == "Monthly") {
                                  DateTime dest = DateTime(
                                    selectedDate.year,
                                    selectedDate.month - 1,
                                    selectedDate.day,
                                    selectedDate.hour,
                                    selectedDate.minute,
                                    selectedDate.second,
                                    selectedDate.millisecond,
                                    selectedDate.microsecond,
                                  );
                                  Duration difference =
                                      dest.difference(selectedDate);
                                  selectedDate = selectedDate.add(difference);
                                } else if (rangeType == "Yearly") {
                                  DateTime dest = DateTime(
                                    selectedDate.year - 1,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedDate.hour,
                                    selectedDate.minute,
                                    selectedDate.second,
                                    selectedDate.millisecond,
                                    selectedDate.microsecond,
                                  );
                                  Duration difference =
                                      dest.difference(selectedDate);
                                  selectedDate = selectedDate.add(difference);
                                }
                                selectedYearController.value =
                                    selectedDate.year;
                                selectedMonthController.value =
                                    selectedDate.month;
                                selectedDayController.value = selectedDate.day;
                              });
                            },
                            child: const Icon(Icons.keyboard_arrow_left)),
                      )
                    : Container(),
                MyDropdownButton(
                    items: const [
                      "Daily",
                      "Weekly",
                      "Monthly",
                      "Yearly",
                      "Overall",
                      "Custom",
                      "Today",
                    ],
                    selectedItem: selectedRangeTypeController,
                    onChanged: () {
                      setState(() {
                        rangeType = selectedRangeTypeController.value;
                        if (rangeType == "Custom") {
                          _selectDateRange(context);
                          return;
                        }
                        if (rangeType == "Today") {
                          selectedDate = DateTime.now();
                          selectedRangeTypeController.value = "Daily";
                          rangeType = selectedRangeTypeController.value;
                          selectedYearController.value = selectedDate.year;
                          selectedMonthController.value = selectedDate.month;
                          selectedDayController.value = selectedDate.day;
                          return;
                        }
                      });
                    }),
                rangeType != "Overall" && rangeType != "Custom"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (rangeType == "Daily") {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 1));
                                } else if (rangeType == "Weekly") {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 7));
                                } else if (rangeType == "Monthly") {
                                  DateTime dest = DateTime(
                                    selectedDate.year,
                                    selectedDate.month + 1,
                                    selectedDate.day,
                                    selectedDate.hour,
                                    selectedDate.minute,
                                    selectedDate.second,
                                    selectedDate.millisecond,
                                    selectedDate.microsecond,
                                  );
                                  Duration difference =
                                      dest.difference(selectedDate);
                                  selectedDate = selectedDate.add(difference);
                                } else if (rangeType == "Yearly") {
                                  DateTime dest = DateTime(
                                    selectedDate.year + 1,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedDate.hour,
                                    selectedDate.minute,
                                    selectedDate.second,
                                    selectedDate.millisecond,
                                    selectedDate.microsecond,
                                  );
                                  Duration difference =
                                      dest.difference(selectedDate);
                                  selectedDate = selectedDate.add(difference);
                                }
                                selectedYearController.value =
                                    selectedDate.year;
                                selectedMonthController.value =
                                    selectedDate.month;
                                selectedDayController.value = selectedDate.day;
                              });
                            },
                            child: const Icon(Icons.keyboard_arrow_right)),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      );
    });
  }
}
