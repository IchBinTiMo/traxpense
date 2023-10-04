import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:traxpense/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}
