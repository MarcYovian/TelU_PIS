import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_v3/src/constants/my_icon.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_service.dart';
import 'package:parking_v3/src/features/parking/data/parking_repository.dart';
import 'package:parking_v3/src/features/parking/presentation/qr_code.dart';
import 'package:parking_v3/src/features/parking/presentation/widget/parking_zone.dart';
import 'package:parking_v3/src/features/profile/domain/profile.dart';
import 'package:provider/provider.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ParkingRepository _parkingRepository = ParkingRepository();
  Profile? profile;

  void showBackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Want to leave"),
          content: const Text("Are you sure you want to leave this Apps? "),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Sure"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var uid = _auth.currentUser!.uid;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showBackDialog();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF7F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEDF7F9),
          automaticallyImplyLeading: false,
          bottomOpacity: 1.0,
          foregroundColor: Colors.white10,
          leading: _auth.currentUser != null
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, myProfileScreen);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: StreamBuilder(
                        stream: _parkingRepository.getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("error : ${snapshot.error}"),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          profile = Profile.fromMap(
                            snapshot.data!.data() as Map<String, dynamic>,
                          );
                          return Image.network(
                            profile!.image,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
          title: const Center(
            child: Text(
              "PARKING ZONE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A1D81),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, myParkingScreen, arguments: {
                  'myProfile': profile,
                });
              },
              icon: const Icon(
                MyIcons.directions_car_rounded,
                color: Color(0xff0A1D81),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ),
                );
              },
              icon: const Icon(
                Icons.qr_code,
                color: Color(0xff0A1D81),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final authService = Provider.of<AuthService>(
                              context,
                              listen: false,
                            );
                            await authService.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, authGate);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Color(0xff0A1D81),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth <= 380) {
                return ParkingZone(
                  parkingRepository: _parkingRepository,
                  uid: uid,
                  heightSpot: 55,
                  heightImage: 35,
                  spotPL: 10,
                  spotPT: 10,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  currentSpotFontSize: 18,
                  currentSpotFontWeight: FontWeight.bold,
                  spotFontSize: 16,
                  spotFontWeight: FontWeight.w600,
                  slotFontSize: 16,
                  slotFontWeight: FontWeight.w600,
                  centerAreaFlex: 1,
                  leftAreaFlex: 2,
                  rightAreaFlex: 2,
                  entryFontSize: 16,
                  entryFontWeight: FontWeight.w500,
                  entryHeightImage: 35,
                  entryIconSize: 20,
                );
              } else if (constraints.maxWidth > 380 &&
                  constraints.maxWidth <= 530) {
                return ParkingZone(
                  parkingRepository: _parkingRepository,
                  uid: uid,
                  heightSpot: 75,
                  heightImage: 45,
                  spotPL: 10,
                  spotPT: 10,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  currentSpotFontSize: 20,
                  currentSpotFontWeight: FontWeight.bold,
                  spotFontSize: 18,
                  spotFontWeight: FontWeight.bold,
                  slotFontSize: 18,
                  slotFontWeight: FontWeight.bold,
                  centerAreaFlex: 1,
                  leftAreaFlex: 2,
                  rightAreaFlex: 2,
                  entryFontSize: 16,
                  entryFontWeight: FontWeight.w500,
                  entryHeightImage: 45,
                  entryIconSize: 20,
                );
              } else if (constraints.maxWidth > 530 &&
                  constraints.maxWidth <= 678) {
                return ParkingZone(
                  parkingRepository: _parkingRepository,
                  uid: uid,
                  heightSpot: 100,
                  heightImage: 60,
                  spotPL: 20,
                  spotPT: 15,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  currentSpotFontSize: 24,
                  currentSpotFontWeight: FontWeight.bold,
                  spotFontSize: 22,
                  spotFontWeight: FontWeight.bold,
                  slotFontSize: 22,
                  slotFontWeight: FontWeight.bold,
                  leftAreaFlex: 3,
                  centerAreaFlex: 2,
                  rightAreaFlex: 3,
                  entryFontSize: 22,
                  entryFontWeight: FontWeight.w500,
                  entryHeightImage: 80,
                  entryIconSize: 30,
                );
              } else if (constraints.maxWidth > 678 &&
                  constraints.maxWidth <= 920) {
                return ParkingZone(
                  parkingRepository: _parkingRepository,
                  uid: uid,
                  heightSpot: 120,
                  heightImage: 60,
                  spotPL: 20,
                  spotPT: 15,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  currentSpotFontSize: 30,
                  currentSpotFontWeight: FontWeight.bold,
                  spotFontSize: 28,
                  spotFontWeight: FontWeight.bold,
                  slotFontSize: 26,
                  slotFontWeight: FontWeight.bold,
                  leftAreaFlex: 4,
                  centerAreaFlex: 3,
                  rightAreaFlex: 4,
                  entryFontSize: 26,
                  entryFontWeight: FontWeight.w500,
                  entryHeightImage: 85,
                  entryIconSize: 45,
                );
              } else {
                return ParkingZone(
                  parkingRepository: _parkingRepository,
                  uid: uid,
                  heightSpot: 140,
                  heightImage: 100,
                  spotPL: 20,
                  spotPT: 15,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  currentSpotFontSize: 32,
                  currentSpotFontWeight: FontWeight.bold,
                  spotFontSize: 30,
                  spotFontWeight: FontWeight.bold,
                  slotFontSize: 28,
                  slotFontWeight: FontWeight.bold,
                  leftAreaFlex: 4,
                  centerAreaFlex: 3,
                  rightAreaFlex: 4,
                  entryFontSize: 28,
                  entryFontWeight: FontWeight.bold,
                  entryHeightImage: 80,
                  entryIconSize: 45,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
