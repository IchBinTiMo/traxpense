import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: SizedBox(
        height: 150,
        child: AppBar(
            title: const Text('Half Screen AppBar'),
            backgroundColor: Colors.blue,
            elevation: 0,
            automaticallyImplyLeading: false,
            bottom: const TabBar(tabs: [
              Tab(
                text: "Daily",
              ),
              Tab(
                text: "Weekly",
              ),
              Tab(
                text: "Monthly",
              ),
              Tab(
                text: "Yearly",
              ),
              Tab(
                text: "All",
              ),
            ])),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
