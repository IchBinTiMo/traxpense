// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:traxpense/components/my_datepicker.dart';
// import 'package:traxpense/components/my_dropdownbutton.dart';

// class DialogBox extends StatelessWidget {
//   final TextEditingController newExpNameController;
//   final TextEditingController newExpAmountController;

//   final ValueNotifier<String> selectedTypeController;

//   // final ValueNotifier<int> selectedYearController;
//   // final ValueNotifier<int> selectedMonthController;
//   // final ValueNotifier<int> selectedDayController;

//   final DateRangePickerController selectedDateController;

//   final List<DateTime> allEventDays;

//   final VoidCallback save;
//   final VoidCallback cancel;

//   const DialogBox(
//       {super.key,
//       required this.newExpNameController,
//       required this.newExpAmountController,
//       required this.selectedTypeController,
//       // required this.selectedYearController,
//       // required this.selectedMonthController,
//       // required this.selectedDayController,
//       required this.selectedDateController,
//       required this.allEventDays,
//       required this.save,
//       required this.cancel});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: const SizedBox(
//           height: 20,
//           child: Text("Add New Expense"),
//         ),
//         content: SizedBox(
//           // height: 200,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // expense name
//               SizedBox(
//                 height: 20,
//                 child: TextField(
//                   controller: newExpNameController,
//                   decoration: const InputDecoration(
//                     hintText: "Expense Name",
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               // expense amount
//               TextField(
//                 controller: newExpAmountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   hintText: "Expense amount",
//                   hintStyle: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               MyDropdownButton(items: const [
//                 // "",
//                 "Food",
//                 "Clothing",
//                 "Housing",
//                 "Transportation",
//                 "Education",
//                 "Entertainment",
//                 "Health",
//                 "Others"
//               ], selectedItem: selectedTypeController),
//               MaterialButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.background,
//                           title: const Text("Go to"),
//                           content: SizedBox(
//                             height: 300,
//                             width: 800,
//                             child: SfDateRangePicker(
//                               controller: selectedDateController,
//                               initialSelectedDate: DateTime.now(),
//                               initialDisplayDate:
//                                   selectedDateController.selectedDate,
//                               onSelectionChanged:
//                                   (dateRangePickerSelectionChangedArgs) {
//                                 // var logger = Logger();
//                                 // logger
//                                 //     .d(dateRangePickerSelectionChangedArgs.value);
//                                 // logger.d(gotoDateController.selectedDate);
//                                 // setState(() {
//                                 //   rangeType = "Daily";
//                                 //   selectedDate =
//                                 //       dateRangePickerSelectionChangedArgs.value;
//                                 //   selectedYearController.value =
//                                 //       selectedDate.year;
//                                 //   selectedMonthController.value =
//                                 //       selectedDate.month;
//                                 //   selectedDayController.value = selectedDate.day;
//                                 // });
//                                 Navigator.of(context).pop();
//                               },
//                               view: DateRangePickerView.month,
//                               maxDate: DateTime.now(),
//                               todayHighlightColor:
//                                   Theme.of(context).colorScheme.tertiary,
//                               monthViewSettings:
//                                   DateRangePickerMonthViewSettings(
//                                 showWeekNumber: true,
//                                 specialDates: allEventDays,
//                               ),
//                               monthCellStyle: DateRangePickerMonthCellStyle(
//                                   textStyle: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                   ),
//                                   specialDatesDecoration: BoxDecoration(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .background,
//                                     border: Border.all(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   disabledDatesTextStyle: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.secondary,
//                                   )),
//                             ),
//                           ),
//                         );
//                       });
//                 },
//                 child: Text(
//                   "${selectedDateController.selectedDate!.year} - ${selectedDateController.selectedDate!.month} - ${selectedDateController.selectedDate!.day}",
//                 ),
//               )
//               // MyDatePicker(
//               //   selectedYear: selectedYearController,
//               //   selectedMonth: selectedMonthController,
//               //   selectedDay: selectedDayController,
//               // ),
//             ],
//           ),
//         ),
//         actions: [
//           // save button
//           MaterialButton(onPressed: save, child: const Text("Save")),
//           // cancel button
//           MaterialButton(onPressed: cancel, child: const Text("Cancel"))
//         ]);
//   }
// }

// class DialogBox extends StatefulWidget {
//   final TextEditingController newExpNameController;
//   final TextEditingController newExpAmountController;

//   final ValueNotifier<String> selectedTypeController;

//   // final ValueNotifier<int> selectedYearController;
//   // final ValueNotifier<int> selectedMonthController;
//   // final ValueNotifier<int> selectedDayController;

//   final DateRangePickerController selectedDateController;

//   final List<DateTime> allEventDays;

//   final VoidCallback save;
//   final VoidCallback cancel;

//   const DialogBox(
//       {super.key,
//       required this.newExpNameController,
//       required this.newExpAmountController,
//       required this.selectedTypeController,
//       // required this.selectedYearController,
//       // required this.selectedMonthController,
//       // required this.selectedDayController,
//       required this.selectedDateController,
//       required this.allEventDays,
//       required this.save,
//       required this.cancel});

//   @override
//   State<DialogBox> createState() => _DialogBoxState();
// }

// class _DialogBoxState extends State<DialogBox> {
//   // get newExpNameController => null;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: const SizedBox(
//           height: 20,
//           child: Text("Add New Expense"),
//         ),
//         content: SizedBox(
//           // height: 200,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // expense name
//               SizedBox(
//                 height: 20,
//                 child: TextField(
//                   controller: newExpNameController,
//                   decoration: const InputDecoration(
//                     hintText: "Expense Name",
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               // expense amount
//               TextField(
//                 controller: newExpAmountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   hintText: "Expense amount",
//                   hintStyle: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               MyDropdownButton(items: const [
//                 // "",
//                 "Food",
//                 "Clothing",
//                 "Housing",
//                 "Transportation",
//                 "Education",
//                 "Entertainment",
//                 "Health",
//                 "Others"
//               ], selectedItem: selectedTypeController),
//               MaterialButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.background,
//                           title: const Text("Go to"),
//                           content: SizedBox(
//                             height: 300,
//                             width: 800,
//                             child: SfDateRangePicker(
//                               controller: selectedDateController,
//                               initialSelectedDate: DateTime.now(),
//                               initialDisplayDate:
//                                   selectedDateController.selectedDate,
//                               onSelectionChanged:
//                                   (dateRangePickerSelectionChangedArgs) {
//                                 // var logger = Logger();
//                                 // logger
//                                 //     .d(dateRangePickerSelectionChangedArgs.value);
//                                 // logger.d(gotoDateController.selectedDate);
//                                 // setState(() {
//                                 //   rangeType = "Daily";
//                                 //   selectedDate =
//                                 //       dateRangePickerSelectionChangedArgs.value;
//                                 //   selectedYearController.value =
//                                 //       selectedDate.year;
//                                 //   selectedMonthController.value =
//                                 //       selectedDate.month;
//                                 //   selectedDayController.value = selectedDate.day;
//                                 // });
//                                 Navigator.of(context).pop();
//                               },
//                               view: DateRangePickerView.month,
//                               maxDate: DateTime.now(),
//                               todayHighlightColor:
//                                   Theme.of(context).colorScheme.tertiary,
//                               monthViewSettings:
//                                   DateRangePickerMonthViewSettings(
//                                 showWeekNumber: true,
//                                 specialDates: allEventDays,
//                               ),
//                               monthCellStyle: DateRangePickerMonthCellStyle(
//                                   textStyle: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                   ),
//                                   specialDatesDecoration: BoxDecoration(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .background,
//                                     border: Border.all(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   disabledDatesTextStyle: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.secondary,
//                                   )),
//                             ),
//                           ),
//                         );
//                       });
//                 },
//                 child: Text(
//                   "${selectedDateController.selectedDate!.year} - ${selectedDateController.selectedDate!.month} - ${selectedDateController.selectedDate!.day}",
//                 ),
//               )
//               // MyDatePicker(
//               //   selectedYear: selectedYearController,
//               //   selectedMonth: selectedMonthController,
//               //   selectedDay: selectedDayController,
//               // ),
//             ],
//           ),
//         ),
//         actions: [
//           // save button
//           MaterialButton(onPressed: save, child: const Text("Save")),
//           // cancel button
//           MaterialButton(onPressed: cancel, child: const Text("Cancel"))
//         ]);
//   }
// }
