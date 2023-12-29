import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:parking_v3/src/features/parking/presentation/qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var total = 0;
    var availableSpots = 0;
    var occupiedSpots = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parking"),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: StreamBuilder(
              stream: database.ref('smart_parking/blocks').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final data = snapshot.data!.snapshot;
                  total = data.child('1/A').children.length +
                      data.child('1/B').children.length;
                  availableSpots =
                      (data.child('1/A/isFilled').value as bool ? 0 : 1) +
                          (data.child('1/B/isFilled').value as bool ? 0 : 1) +
                          (data.child('2/A/isFilled').value as bool ? 0 : 1) +
                          (data.child('2/B/isFilled').value as bool ? 0 : 1);
                  occupiedSpots =
                      (data.child('1/A/isFilled').value as bool ? 1 : 0) +
                          (data.child('1/B/isFilled').value as bool ? 1 : 0) +
                          (data.child('2/A/isFilled').value as bool ? 1 : 0) +
                          (data.child('2/B/isFilled').value as bool ? 1 : 0);
                  return Center(
                    child: Column(
                      children: [
                        Text("Total Parkir = ${total.toString()}"),
                        Text(
                            "Total Spot Kosong = ${availableSpots.toString()}"),
                        Text(
                            "Total Spot Terpakai = ${occupiedSpots.toString()}"),
                        // Text(data2.toString()),
                      ],
                    ),
                  );
                } else {
                  return Text("Error : ${snapshot.error}");
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: database.ref("smart_parking/blocks").onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  print(data.snapshot.child("1/A/isFilled").value);
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ParkingSpot(
                                "A",
                                "1",
                                data.snapshot.child("1/A/isFilled").value
                                    as bool),
                            ParkingSpot(
                                "A",
                                "2",
                                data.snapshot.child("2/A/isFilled").value
                                    as bool)
                          ],
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Text("Hello"),
                        ),
                        Column(
                          children: [
                            ParkingSpot(
                                "B",
                                "1",
                                data.snapshot.child("1/B/isFilled").value
                                    as bool),
                            ParkingSpot(
                                "B",
                                "2",
                                data.snapshot.child("2/B/isFilled").value
                                    as bool)
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Text("data");
              },
            ),
            // FirebaseAnimatedList(
            //   query: database.ref("smart_parking/blocks"),
            //   defaultChild: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            //   itemBuilder: (context, snapshot, animation, index) {
            //     Map block = snapshot.value as Map;
            //     block['key'] = snapshot.key; // 1 & 2
            //     return Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           ParkingSpot("A", block["key"].toString(), block),
            //           ParkingSpot("B", block["key"].toString(), block),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ),
          );
        },
        icon: const Icon(Icons.camera),
      ),
    );
  }
}

class ParkingSpot extends StatelessWidget {
  final String block;
  final String spot;
  final bool data;

  const ParkingSpot(this.block, this.spot, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isFilled = data;
    bool isBlockA = (block == "A");

    return isFilled
        ? Container(
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              color: isFilled ? Colors.red.shade300 : Colors.green.shade100,
              border: Border(
                bottom: const BorderSide(color: Colors.black, width: 1.5),
                left: isBlockA
                    ? const BorderSide(color: Colors.black, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 2),
                top: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Image(
                image: AssetImage("assets/images/car.png"),
                alignment: Alignment.center,
                height: 60,
              ),
            ),
          )
        : Container(
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              color: isFilled ? Colors.red.shade100 : Colors.green.shade300,
              border: Border(
                bottom: const BorderSide(color: Colors.black, width: 1.5),
                left: isBlockA
                    ? const BorderSide(color: Colors.black, width: 2)
                    : BorderSide.none,
                right: isBlockA
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 2),
                top: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text('$block - $spot'),
            ),
          );
  }
}
