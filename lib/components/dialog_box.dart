import 'package:flutter/material.dart';
import 'package:traxpense/components/my_datepicker.dart';
import 'package:traxpense/components/my_dropdownbutton.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController newExpNameController;
  final TextEditingController newExpAmountController;

  final ValueNotifier<String> selectedTypeController;

  final ValueNotifier<int> selectedYearController;
  final ValueNotifier<int> selectedMonthController;
  final ValueNotifier<int> selectedDayController;

  final VoidCallback save;
  final VoidCallback cancel;

  const DialogBox(
      {super.key,
      required this.newExpNameController,
      required this.newExpAmountController,
      required this.selectedTypeController,
      required this.selectedYearController,
      required this.selectedMonthController,
      required this.selectedDayController,
      required this.save,
      required this.cancel});

  @override
  Widget build(BuildContext context) {
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
  }
}
