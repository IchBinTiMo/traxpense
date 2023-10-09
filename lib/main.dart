import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:traxpense/data/database.dart';
import 'package:traxpense/data/expense_data.dart';
import 'package:traxpense/data/theme_provider.dart';
import 'package:traxpense/helpers/daily_expense.dart';
import 'package:traxpense/helpers/expense_item.dart';
import 'package:traxpense/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:traxpense/theme/theme.dart';

void main() async {
  // register adaptors for custom objects
  Hive.registerAdapter(ExpenseItemAdapter());
  Hive.registerAdapter(DailyExpenseAdapter());
  // Hive.registerAdapter(ThemeProviderAdapter());

  // initial hive database
  await Hive.initFlutter();

  // await Hive.deleteBoxFromDisk('expense_db');

  // open the box
  await Hive.openBox('expense_db');

  // final db = ExpensesDataBase();

  // final myBox = Hive.box('expense_db');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final _myBox = Hive.box('expense_db');
  // final db = ExpensesDataBase();

  // @override
  // void initState() {
  //   super.initState();

  // }
  // Provider.of<ThemeProvider>(context).themdData;

  // Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (context) => ExpenseData(),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: lightMode,
          // darkTheme: darkMode,
          // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
          theme: Provider.of<ThemeProvider>(context).themeData,
          themeAnimationDuration: Duration.zero,
          // theme: theme == "light" ? lightMode : darkMode,
          home: const HomePage(),
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // final _myBox = Hive.box('expense_db');
//   // final db = ExpensesDataBase();

//   // @override
//   // void initState() {
//   //   super.initState();

//   // }
//   // Provider.of<ThemeProvider>(context).themdData;

//   // Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: ChangeNotifierProvider(
//         create: (context) => ExpenseData(),
//         builder: (context, child) => MaterialApp(
//           debugShowCheckedModeBanner: false,
//           // theme: lightMode,
//           // darkTheme: darkMode,
//           // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//           theme: Provider.of<ThemeProvider>(context).themeData,
//           // theme: theme == "light" ? lightMode : darkMode,
//           home: const HomePage(),
//         ),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   // final String theme;
//   const MyApp({super.key});

//   // final _myBox = Hive.box('expense_db');
//   // final db = ExpensesDataBase();

//   // @override
//   // void initState() {
//   //   super.initState();

//   // }
//   // Provider.of<ThemeProvider>(context).themdData;

//   // Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: Consumer<ThemeProvider>(builder: (context, myTheme, child) {
//         return ChangeNotifierProvider(
//           create: (context) => ExpenseData(),
//           builder: (context, child) => MaterialApp(
//             debugShowCheckedModeBanner: false,
//             // theme: lightMode,
//             // darkTheme: darkMode,
//             // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//             // theme: myTheme.themeData,
//             theme: Provider.of<ThemeProvider>(context).themeData,
//             // theme: theme == "light" ? lightMode : darkMode,
//             home: const HomePage(),
//           ),
//         );
//       }),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // final _myBox = Hive.box('expense_db');
//   // final db = ExpensesDataBase();

//   // @override
//   // void initState() {
//   //   super.initState();

//   // }
//   // Provider.of<ThemeProvider>(context).themdData;

//   // Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: ChangeNotifierProvider(
//         create: (_) => ExpenseData(),
//         // builder: (context, child) => MaterialApp(
//         //   debugShowCheckedModeBanner: false,
//         //   // theme: lightMode,
//         //   // darkTheme: darkMode,
//         //   // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//         //   // theme: Provider.of<ThemeProvider>(context).themeData,
//         //   theme: Provider.of<ThemeProvider>(context).themeData,
//         //   home: const HomePage(),
//         // ),
//         child: Consumer(builder: (context, manager, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             // theme: lightMode,
//             // darkTheme: darkMode,
//             // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//             // theme: Provider.of<ThemeProvider>(context).themeData,
//             theme: manager.t,
//             home: const HomePage(),
//           );
//         }),
//       ),
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _myBox = Hive.box('expense_db');
//   bool flag = false;
//   ExpensesDataBase db = ExpensesDataBase();

//   // @override
//   // void initState() {
//   //   Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);
//   //   super.initState();
//   // }

//   @override
//   void initState() {
//     if (_myBox.get("expensesByDay") != null) {
//       db.loadData();
//     } else {
//       db.createInitialData();
//     }
//     Provider.of<ThemeProvider>(context, listen: false).loadThemeFromDB(db);
//     super.initState();
//   }

//   ThemeData getThemeData() {
//     // if (flag == false) {
//     //   flag = true;
//     //   return _myBox.get("theme") == "light" ? lightMode : darkMode;
//     // }
//     return Provider.of<ThemeProvider>(context).themeData;
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return ChangeNotifierProvider(
//   //     create: (context) => ThemeProvider(),
//   //     child: ChangeNotifierProvider(
//   //       create: (context) => ExpenseData(),
//   //       builder: (context, child) => MaterialApp(
//   //         debugShowCheckedModeBanner: false,
//   //         // theme: lightMode,
//   //         // darkTheme: darkMode,
//   //         // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//   //         // theme: Provider.of<ThemeProvider>(context).themeData,
//   //         theme: getThemeData(),
//   //         home: const HomePage(),
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: ChangeNotifierProvider(
//         create: (context) => ExpenseData(),
//         builder: (context, child) => MaterialApp(
//           debugShowCheckedModeBanner: false,
//           // theme: lightMode,
//           // darkTheme: darkMode,
//           // theme: _myBox.get("theme") == "light" ? lightMode : darkMode,
//           theme: Provider.of<ThemeProvider>(context).themeData,
//           // theme: theme == "light" ? lightMode : darkMode,
//           home: const HomePage(),
//         ),
//       ),
//     );
//   }
// }
