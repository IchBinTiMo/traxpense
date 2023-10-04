import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade900,
    secondary: Colors.red.shade500,
    onSurface: Colors.green.shade500,
    onBackground: Colors.blue.shade500,
    onSecondary: Colors.grey.shade300,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade300,
    onSecondary: Colors.grey.shade900,
  ),
);
