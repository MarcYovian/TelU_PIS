import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/my_parking/data/my_parking_service.dart';
import 'package:parking_v3/src/features/profile/domain/profile.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyParkingScreen extends StatefulWidget {
  final Profile myProfile;
  const MyParkingScreen({
    super.key,
    required this.myProfile,
  });

  @override
  State<MyParkingScreen> createState() => _MyParkingScreenState();
}

class _MyParkingScreenState extends State<MyParkingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic> data = {};

  Duration duration = const Duration();
  Timer? timer;
  bool isParking = false;

  @override
  void initState() {
    super.initState();

    initTime();

    startTimer();
    Future.delayed(const Duration(milliseconds: 5000));
  }

  void addTime() {
    if (isParking) {
      const addSeconds = 1;

      setState(() {
        final seconds = duration.inSeconds + addSeconds;

        duration = Duration(seconds: seconds);
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void initTime() async {
    var logs = await MyParkingService().getLogsData(_auth.currentUser!.uid);
    Map<String, dynamic> map = logs.data() as Map<String, dynamic>;
    setState(() {
      isParking = (map['outAt'] == null);
    });
    if (isParking) {
      var date = (map['inAt'] as Timestamp).toDate();
      var currentDate = Timestamp.now().toDate();
      var time = currentDate.difference(date);
      // print(time.inSeconds);
      setState(() {
        duration = Duration(seconds: time.inSeconds);
        data = map;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDF7F9),
        automaticallyImplyLeading: false,
        bottomOpacity: 1.0,
        foregroundColor: Colors.white10,
        title: const Center(
          child: Text(
            "My Parking",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff0A1D81),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, myProfileScreen);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  widget.myProfile.image,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCircular(),
              const Gap(30),
              const Text(
                "Parking Time",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildTime(),
              if (data.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['value'],
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFC1037),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircular() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    double percent = ((double.parse(minutes)) / 60);

    return CircularPercentIndicator(
      radius: 200,
      lineWidth: 30,
      percent: percent,
      progressColor: const Color(0xFFFC1037),
      backgroundColor: const Color(0xFFF4B0BA),
      circularStrokeCap: CircularStrokeCap.round,
      center: const RotatedBox(
        quarterTurns: 1,
        child: Opacity(
          opacity: 0.8,
          child: Image(
            image: AssetImage("assets/images/red_car.png"),
            width: 270,
          ),
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      "$hours:$minutes:$seconds",
      style: const TextStyle(
        fontSize: 60,
      ),
    );
  }
}
