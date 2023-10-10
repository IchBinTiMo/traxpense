import 'package:flutter/material.dart';

class MyDropdownButton extends StatelessWidget {
  final List<String> items;
  final ValueNotifier<String> selectedItem;
  final VoidCallback? onChanged;

  const MyDropdownButton(
      {super.key,
      required this.items,
      required this.selectedItem,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedItem,
      builder: (BuildContext context, String value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: (newValue) {
                if (newValue != "Today") {
                  selectedItem.value = newValue!;
                  onChanged?.call();
                  return;
                }
                selectedItem.value = "Today";
                onChanged?.call();
                return;
              },
              iconSize: items[0] == "Daily" ? 0 : 24,
              dropdownColor: Theme.of(context).colorScheme.background,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: SizedBox(
                    width: items[0] == "Daily" ? 70 : null,
                    child: Text(
                      item,
                      textAlign: items[0] == "Daily" ? TextAlign.center : null,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
