import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:traxpense/data/database.dart';
import 'package:traxpense/theme/theme.dart';

part 'theme_provider.g.dart';

@HiveType(typeId: 2)
class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;

  ThemeData get themeData => _themeData;

  ThemeProvider() {
    loadThemeFromDB(ExpensesDataBase());
  }

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  void loadThemeFromDB(ExpensesDataBase db) async {
    _themeData = db.themeNow == "light" ? lightMode : darkMode;
    await _delayed(true, Duration.zero);
    notifyListeners();
  }

  void toggleTheme(ExpensesDataBase db) {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
    db.themeNow = _themeData == lightMode ? "light" : "dark";
    db.updateTheme();
  }

  Future<dynamic> _delayed(dynamic returnVal, Duration duration) {
    return Future.delayed(duration, () => returnVal);
  }
}
