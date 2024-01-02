import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_service.dart';
import 'package:parking_v3/src/features/parking/data/parking_repository.dart';
import 'package:parking_v3/src/features/parking/presentation/qr_code.dart';
import 'package:parking_v3/src/features/profile/domain/profile.dart';
import 'package:provider/provider.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final ParkingRepository _parkingRepository = ParkingRepository();

  @override
  Widget build(BuildContext context) {
    var availableSpots = 0;
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDF7F9),
        automaticallyImplyLeading: false,
        bottomOpacity: 1.0,
        foregroundColor: Colors.white10,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRViewExample(),
                ),
              );
            },
            icon: const Icon(
              Icons.camera,
              color: Color(0xff0A1D81),
            ),
          ),
          _auth.currentUser != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: GestureDetector(
                    onTap: () {},
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

                          Profile profile = Profile.fromMap(
                            snapshot.data!.data() as Map<String, dynamic>,
                          );
                          return Image.network(
                            profile.image,
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
          IconButton(
            onPressed: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              await authService.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, authGate);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xff0A1D81),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _database.ref('smart_parking/blocks').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error : ${snapshot.error}"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                var data = snapshot.data!.snapshot;
                print(data.child('2').value);
                // var block_1 = data.child('1').value as Map<String, dynamic>;
                // var block_2 = data.child('2').value as Map<String, dynamic>;
                return const Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Text(
                          "Your Parking Spot :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          "A-1",
                          style: TextStyle(
                            color: Color(0xff0A1D81),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Center(
              child: StreamBuilder(
                stream: _parkingRepository.getDataParking(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.data!;
                  availableSpots =
                      (data.snapshot.child('1/A/isFilled').value as bool
                              ? 0
                              : 1) +
                          (data.snapshot.child('1/B/isFilled').value as bool
                              ? 0
                              : 1) +
                          (data.snapshot.child('2/A/isFilled').value as bool
                              ? 0
                              : 1) +
                          (data.snapshot.child('2/B/isFilled').value as bool
                              ? 0
                              : 1);
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                height: 75,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 53,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(100),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: Colors.black26,
                                      width: 2,
                                    ),
                                    right: BorderSide(
                                      color: Colors.black26,
                                      width: 1.5,
                                    ),
                                    top: BorderSide(
                                      color: Colors.black26,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              ParkingSpot(
                                "A",
                                "1",
                                data.snapshot.child("1/A/isFilled").value
                                    as bool,
                                isLeft: true,
                              ),
                              ParkingSpot(
                                "A",
                                "2",
                                data.snapshot.child("2/A/isFilled").value
                                    as bool,
                                isLeft: true,
                              ),
                              Container(
                                height: 75,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 53,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(100),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: Colors.black26,
                                      width: 2,
                                    ),
                                    right: BorderSide(
                                      color: Colors.black26,
                                      width: 1.5,
                                    ),
                                    top: BorderSide(
                                      color: Colors.black26,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            "${availableSpots.toString()} SLOT FREE",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 75,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      53,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                      right: BorderSide(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      top: BorderSide(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                ParkingSpot(
                                  "B",
                                  "1",
                                  data.snapshot.child("1/B/isFilled").value
                                      as bool,
                                  isLeft: false,
                                ),
                                ParkingSpot(
                                  "B",
                                  "2",
                                  data.snapshot.child("2/B/isFilled").value
                                      as bool,
                                  isLeft: false,
                                ),
                                Container(
                                  height: 75,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      53,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                      right: BorderSide(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      top: BorderSide(
                                        color: Colors.black26,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Expanded(
            // flex: 1,
            child: Center(
              child: Column(
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Image(
                      image: AssetImage("assets/images/car.png"),
                      opacity: AlwaysStoppedAnimation(0.3),
                      alignment: Alignment.center,
                      height: 45,
                    ),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.black26,
                  ),
                  Text(
                    "ENTRY",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ParkingSpot extends StatelessWidget {
  final String block;
  final String spot;
  final bool data;
  final bool isLeft;

  const ParkingSpot(
    this.block,
    this.spot,
    this.data, {
    super.key,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    bool isFilled = data;
    bool isBlockA = (block == "A");

    return isFilled
        ? Container(
            width: MediaQuery.of(context).size.width / 2 - 53,
            height: 75,
            decoration: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.black26, width: 0),
                left: isBlockA
                    ? const BorderSide(color: Colors.black26, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black26, width: 2),
                top: const BorderSide(color: Colors.black26, width: 1.5),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: isLeft
                  ? const RotatedBox(
                      quarterTurns: -2,
                      child: Image(
                        image: AssetImage("assets/images/car.png"),
                        alignment: Alignment.center,
                        height: 45,
                      ),
                    )
                  : const Image(
                      image: AssetImage("assets/images/car.png"),
                      alignment: Alignment.center,
                      height: 45,
                    ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width / 2 - 53,
            height: 75,
            decoration: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.black26, width: 0),
                left: isBlockA
                    ? const BorderSide(color: Colors.black26, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black26, width: 2),
                top: const BorderSide(color: Colors.black26, width: 0),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                '$block - $spot',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1D81),
                ),
              ),
            ),
          );
  }
}
