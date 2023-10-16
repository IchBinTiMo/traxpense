import 'package:flutter/material.dart';
import 'package:traxpense/pages/login_page.dart';
import 'package:traxpense/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        toggleScreens: toggleScreens,
      );
    } else {
      return RegisterPage(
        toggleScreens: toggleScreens,
      );
    }
  }
}
