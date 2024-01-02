import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parking_v3/src/features/auth/presentation/login_screen.dart';
import 'package:parking_v3/src/features/auth/presentation/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show the login screen
  bool? showLoginScreen;

  @override
  void initState() {
    super.initState();
    showLoginScreen = true;
  }

  // toggle between login and register screen
  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen!) {
      return LoginScreen(
        onTap: toggleScreen,
      );
    } else {
      return RegisterScreen(
        onTap: toggleScreen,
      );
    }
  }
}
