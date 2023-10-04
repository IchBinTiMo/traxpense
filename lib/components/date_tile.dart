import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  final int value;
  const DateTile({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          value < 10 ? '0$value' : '$value',
        ),
      ),
    );
  }
}
