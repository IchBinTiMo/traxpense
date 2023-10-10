import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traxpense/data/expense_data.dart';
import 'package:traxpense/data/theme_provider.dart';
import 'package:traxpense/helpers/daily_expense.dart';
import 'package:traxpense/helpers/expense_item.dart';
import 'package:traxpense/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // register adaptors for custom objects
  Hive.registerAdapter(ExpenseItemAdapter());
  Hive.registerAdapter(DailyExpenseAdapter());

  // initial hive database
  await Hive.initFlutter();

  // open the box
  await Hive.openBox('expense_db');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (context) => ExpenseData(),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          themeAnimationDuration: Duration.zero,
          home: const HomePage(),
        ),
      ),
    );
  }
}
