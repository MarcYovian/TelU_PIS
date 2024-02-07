import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_v3/src/common_widget/my_bottom.dart';
import 'package:parking_v3/src/common_widget/my_text_field.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_service.dart';
import 'package:parking_v3/src/utils/app_utils.dart';
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
    double width = AppUtils.width(context);

    // print(width);
    // print(height);
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth <= 520) {
                    return Column(
                      children: [
                        Image.asset(
                          "assets/images/logosby.png",
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Parking Information System",
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(50),

                        // Email text field
                        SizedBox(
                          width: width,
                          child: MyTextField(
                            controller: emailController,
                            hintText: "Email",
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
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
                    );
                  } else if (constraints.maxWidth > 520 &&
                      constraints.maxWidth <= 920) {
                    return Column(
                      children: [
                        Image.asset(
                          "assets/images/logosby.png",
                          width: 300.0,
                          height: 300.0,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Parking Information System",
                          style: GoogleFonts.lato(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(50),

                        // Email text field
                        MyTextField(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const Gap(20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Password text field
                            SizedBox(
                              width: (constraints.maxWidth < 620)
                                  ? width / 2.1
                                  : width / 2,
                              child: MyTextField(
                                controller: passwordController,
                                hintText: "Password",
                                obscureText: true,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const Gap(20),

                            // Sign in Button
                            SizedBox(
                              width: width / 2.8,
                              child: MyButton(
                                onTap: signIn,
                                text: "Sign In",
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),

                        // not a member ? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "not a member ?",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            const Gap(4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                "Register now",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Image.asset(
                          "assets/images/logosby.png",
                          width: 400.0,
                          height: 400.0,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Parking Information System",
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(80),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Email text field
                            SizedBox(
                              width: width / 2.25,
                              child: MyTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            const Gap(20),

                            SizedBox(
                              width: width / 2.25,
                              child: MyTextField(
                                controller: passwordController,
                                hintText: "Password",
                                obscureText: true,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),

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
                            const Text(
                              "not a member ?",
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                            const Gap(4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                "Register now",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
