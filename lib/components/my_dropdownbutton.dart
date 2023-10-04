import 'package:flutter/material.dart';

class MyDropdownButton extends StatelessWidget {
  final List<String> items;
  final ValueNotifier<String> selectedItem;
  const MyDropdownButton(
      {super.key, required this.items, required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedItem,
      builder: (BuildContext context, String value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: value,
            onChanged: (newValue) {
              selectedItem.value = newValue!;
            },
            dropdownColor: Theme.of(context).colorScheme.background,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
