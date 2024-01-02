import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/login_or_register.dart';
import 'package:parking_v3/src/features/auth/presentation/login_screen.dart';
import 'package:parking_v3/src/features/parking/presentation/parking_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const ParkingScreen();
          }

          // user in NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
