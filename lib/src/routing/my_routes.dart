import 'package:flutter/material.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_gate.dart';
import 'package:parking_v3/src/features/my_profile/presentation/my_profile_screen.dart';
import 'package:parking_v3/src/features/parking/presentation/parking_screen.dart';

class MyRoutes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case authGate:
        return MaterialPageRoute(
          builder: (context) => const AuthGate(),
        );
      case parkingScreen:
        return MaterialPageRoute(
          builder: (context) => const ParkingScreen(),
        );
      case myProfileScreen:
        return MaterialPageRoute(
          builder: (context) => const MyProfileScreen(),
        );
      default:
    }

    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text("no route defined"),
        ),
      ),
    );
  }
}
