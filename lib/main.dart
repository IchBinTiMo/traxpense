import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traxpense/data/expense_data.dart';
import 'package:traxpense/data/theme_provider.dart';
import 'package:traxpense/pages/home_page.dart';

void main() {
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
          // theme: lightMode,
          // darkTheme: darkMode,
          theme: Provider.of<ThemeProvider>(context).themeData,
          home: const HomePage(),
        ),
      ),
    );
  }
}
