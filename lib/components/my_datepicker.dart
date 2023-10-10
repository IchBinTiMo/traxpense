import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyDatePicker extends StatelessWidget {
  final ValueNotifier<int> selectedYear;
  final ValueNotifier<int> selectedMonth;
  final ValueNotifier<int> selectedDay;

  MyDatePicker(
      {super.key,
      required this.selectedYear,
      required this.selectedMonth,
      required this.selectedDay});

  final List<int> years =
      List.generate(DateTime.now().year, (index) => index + 1);
  final List<int> months = List.generate(12, (index) => index + 1);
  final List<int> days = List.generate(31, (index) => index + 1);

  int hasDays() {
    if ([1, 3, 5, 7, 8, 10, 12].contains(selectedMonth.value)) {
      return 31;
    } else if (selectedMonth.value == 2) {
      // logger.d(selectedYear);
      if (selectedYear.value % 400 == 0) {
        return 29;
      }
      if (selectedYear.value % 100 == 0) {
        return 28;
      }
      if (selectedYear.value % 4 == 0) {
        return 29;
      }
      return 28;
    } else {
      return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // years
          ValueListenableBuilder(
              valueListenable: selectedYear,
              builder: (context, value, child) {
                return SizedBox(
                  width: 70,
                  height: 40,
                  child: Column(
                    children: [
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedYear.value - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          // flag = true;
                          selectedYear.value = years[index];
                        },
                        children: years
                            .map(
                              (e) => Center(
                                child: Text(
                                  e.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
          // months
          ValueListenableBuilder(
              valueListenable: selectedMonth,
              builder: (context, value, child) {
                return SizedBox(
                  width: 70,
                  height: 40,
                  child: Column(
                    children: [
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedMonth.value - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          selectedMonth.value = months[index];
                        },
                        children: months
                            .map(
                              (e) => Center(
                                child: Text(
                                  e.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
          // days
          ValueListenableBuilder(
              valueListenable: selectedDay,
              builder: (context, value, child) {
                return SizedBox(
                  width: 70,
                  height: 40,
                  child: Column(
                    children: [
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedDay.value - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          var logger = Logger();
                          logger.d(index);
                          selectedDay.value = days[index];
                        },
                        children: List.generate(hasDays(), (index) => index + 1)
                            .map(
                              (e) => Center(
                                child: Text(
                                  e.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
