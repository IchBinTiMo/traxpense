import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
import 'package:traxpense/data/database.dart';
// import 'package:traxpense/data/my_theme_preference.dart';
// import 'package:provider/provider.dart';
import 'package:traxpense/theme/theme.dart';

part 'theme_provider.g.dart';

@HiveType(typeId: 2)
class ThemeProvider extends ChangeNotifier {
  // @HiveField(0)
  late ThemeData _themeData;

  // final db = ExpensesDataBase();

  ThemeData get themeData => _themeData;

  ThemeProvider() {
    loadThemeFromDB(ExpensesDataBase());
  }

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  void loadThemeFromDB(ExpensesDataBase db) async {
    // var logger = Logger();
    // logger.d(db.themeNow);
    _themeData = db.themeNow == "light" ? lightMode : darkMode;
    await _delayed(true, Duration.zero);
    notifyListeners();
  }

  void toggleTheme(ExpensesDataBase db) {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
    db.themeNow = _themeData == lightMode ? "light" : "dark";
    db.updateTheme();
    // var logger = Logger();
    // logger.d(db.themeNow);
  }

  Future<dynamic> _delayed(dynamic returnVal, Duration duration) {
    return Future.delayed(duration, () => returnVal);
  }
}

// class ThemeProvider extends ChangeNotifier {
//   // ThemeData _themeData = lightMode; // lightMode;
//   // late bool _isDarkMode;
//   late MyThemePreference _pref;
//   // bool get isDarkMode => _isDarkMode;

//   late ThemeData _themeData;
//   ThemeData get themeData => _themeData;

//   ThemeProvider() {
//     _pref = MyThemePreference();
//     // _isDarkMode = false;
//     _themeData = lightMode;
//     getPreferences();
//   }

//   void toggleTheme() {
//     _themeData = _themeData == darkMode ? lightMode : darkMode;
//     _pref.setTheme(_themeData == darkMode ? "dark" : "light");
//     notifyListeners();
//   }

//   void getPreferences() async {
//     _themeData = await _pref.getTheme() == "light" ? lightMode : darkMode;
//     notifyListeners();
//   }
// }
