// import 'dart:ffi';

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

  // int selectedYear = DateTime.now().year;
  // int selectedMonth = DateTime.now().month;
  // int selectedDay = DateTime.now().day;

  // bool flag = false;

  // @override
  // void initState() {
  //   super.initState();

  // _yearController =
  //     FixedExtentScrollController(initialItem: DateTime.now().year - 1);
  // _monthController =
  //     FixedExtentScrollController(initialItem: DateTime.now().month - 1);
  // _dayController =
  //     FixedExtentScrollController(initialItem: DateTime.now().day - 1);
  // }

  int hasDays() {
    // var logger = Logger();
    // logger.d(days);
    // logger.d([selectedYear, selectedMonth, selectedDay]);
    // if (flag == false) {
    //   return DateTime(selectedYear.value, selectedMonth.value + 1, 0).day;
    // }
    // flag = true;
    // logger.d(selectedMonth);
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
                        // looping: true,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedMonth.value - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          // flag = true;
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
                        // looping: true,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedDay.value - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          // flag = true;
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
  // State<MyDatePicker> createState() => _MyDatePickerState();

// class _MyDatePickerState extends State<MyDatePicker> {
//   // FixedExtentScrollController _dayController = FixedExtentScrollController();
//   List<int> years = List.generate(DateTime.now().year, (index) => index + 1);
//   List<int> months = List.generate(12, (index) => index + 1);
//   List<int> days = List.generate(31, (index) => index + 1);

//   // int selectedYear = DateTime.now().year;
//   // int selectedMonth = DateTime.now().month;
//   // int selectedDay = DateTime.now().day;

//   bool flag = false;

//   @override
//   void initState() {
//     super.initState();

//     // _yearController =
//     //     FixedExtentScrollController(initialItem: DateTime.now().year - 1);
//     // _monthController =
//     //     FixedExtentScrollController(initialItem: DateTime.now().month - 1);
//     // _dayController =
//     //     FixedExtentScrollController(initialItem: DateTime.now().day - 1);
//   }

//   int hasDays() {
//     var logger = Logger();
//     // logger.d(days);
//     logger.d([selectedYear, selectedMonth, selectedDay]);
//     if (flag == false) {
//       return DateTime(selectedYear, selectedMonth + 1, 0).day;
//     }
//     flag = true;
//     // logger.d(selectedMonth);
//     if ([1, 3, 5, 7, 8, 10, 12].contains(selectedMonth)) {
//       return 31;
//     } else if (selectedMonth == 2) {
//       // logger.d(selectedYear);
//       if (selectedYear % 400 == 0) {
//         return 29;
//       }
//       if (selectedYear % 100 == 0) {
//         return 28;
//       }
//       if (selectedYear % 4 == 0) {
//         return 29;
//       }
//       return 28;
//     } else {
//       return 30;
//     }
//   }

//   // int getDaysInCurrentMonth() {
//   //   flag = true;
//   //   return DateTime(selectedYear, selectedMonth + 1, 0).day;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // years
//           ValueListenableBuilder(
//             valueListenable: selectedYear,
//             child: SizedBox(
//               width: 70,
//               height: 40,
//               child: Column(
//                 children: [
//                   CupertinoPicker(
//                     scrollController: FixedExtentScrollController(
//                         initialItem: selectedYear.value - 1),
//                     itemExtent: 30,
//                     onSelectedItemChanged: (index) {
//                       setState(() {
//                         flag = true;
//                         selectedYear = years[index];
//                       });
//                     },
//                     children: years
//                         .map(
//                           (e) => Center(
//                             child: Text(
//                               e.toString(),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // months
//           SizedBox(
//             width: 70,
//             height: 40,
//             child: Column(
//               children: [
//                 CupertinoPicker(
//                   // looping: true,
//                   scrollController: FixedExtentScrollController(
//                       initialItem: selectedMonth - 1),
//                   itemExtent: 30,
//                   onSelectedItemChanged: (index) {
//                     setState(() {
//                       flag = true;
//                       selectedMonth = months[index];
//                     });
//                   },
//                   children: months
//                       .map(
//                         (e) => Center(
//                           child: Text(
//                             e.toString(),
//                           ),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ],
//             ),
//           ),
//           // days
//           SizedBox(
//             width: 70,
//             height: 40,
//             child: Column(
//               children: [
//                 CupertinoPicker(
//                   // looping: true,
//                   scrollController:
//                       FixedExtentScrollController(initialItem: selectedDay - 1),
//                   itemExtent: 30,
//                   onSelectedItemChanged: (index) {
//                     setState(() {
//                       flag = true;
//                       var logger = Logger();
//                       logger.d(index);
//                       selectedDay = days[index];
//                     });
//                   },
//                   children: List.generate(hasDays(), (index) => index + 1)
//                       .map(
//                         (e) => Center(
//                           child: Text(
//                             e.toString(),
//                           ),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyDatePicker extends StatefulWidget {
//   const MyDatePicker({super.key});

//   @override
//   State<MyDatePicker> createState() => _MyDatePickerState();
// }

// class _MyDatePickerState extends State<MyDatePicker> {
//   DateTime selectedDate = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       onPressed: () {
//         showCupertinoModalPopup(
//           context: context,
//           builder: (context) => SizedBox(
//             child: CupertinoDatePicker(
//               // backgroundColor: Colors.white,
//               mode: CupertinoDatePickerMode.date,
//               initialDateTime: selectedDate,
//               maximumDate: DateTime.now(),
//               onDateTimeChanged: (dateTime) {
//                 setState(() {
//                   selectedDate = dateTime;
//                 });
//               },
//             ),
//           ),
//         );
//       },
//       child: Text(
//           "${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}"),
//     );
//   }
// }
