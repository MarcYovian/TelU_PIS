import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_v3/src/common_widget/my_bottom.dart';
import 'package:parking_v3/src/common_widget/my_text_field.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, authGate);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logosby.png",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.fill,
                  ),
                  // Email text field
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(20),

                  // Password text field
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const Gap(20),

                  // Sign in Button
                  MyButton(
                    onTap: signIn,
                    text: "Sign In",
                  ),
                  const Gap(20),

                  // not a member ? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("not a member ?"),
                      const Gap(4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
