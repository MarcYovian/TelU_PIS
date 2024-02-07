import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_v3/src/features/parking/data/parking_repository.dart';
import 'package:parking_v3/src/features/parking/domain/qr.dart';
import 'package:parking_v3/src/features/parking/presentation/widget/parking_spot.dart';

class ParkingZone extends StatelessWidget {
  const ParkingZone({
    super.key,
    required ParkingRepository parkingRepository,
    required this.uid,
    required this.heightSpot,
    this.spotPB = 0,
    this.spotPL = 0,
    this.spotPR = 0,
    this.spotPT = 0,
    this.fontSize = 0,
    this.spotFontSize = 0,
    this.fontWeight = FontWeight.w300,
    this.spotFontWeight = FontWeight.w300,
    this.currentSpotFontSize = 0,
    this.currentSpotFontWeight = FontWeight.w300,
    this.leftAreaFlex = 1,
    this.centerAreaFlex = 1,
    this.rightAreaFlex = 1,
    this.slotFontSize = 0,
    this.slotFontWeight = FontWeight.w300,
    this.entryHeightImage = 0,
    this.entryFontSize = 0,
    this.entryFontWeight = FontWeight.w300,
    this.entryIconSize = 0,
    required this.heightImage,
  }) : _parkingRepository = parkingRepository;

  final ParkingRepository _parkingRepository;
  final String uid;
  final double heightSpot;

  // padding current spot parking
  final double spotPL;
  final double spotPT;
  final double spotPR;
  final double spotPB;

  final double fontSize;
  final FontWeight fontWeight;
  final double currentSpotFontSize;
  final FontWeight currentSpotFontWeight;

  final int leftAreaFlex;
  final int centerAreaFlex;
  final int rightAreaFlex;

  // num slot Parking
  final double slotFontSize;
  final FontWeight slotFontWeight;

  // Spot Parking
  final double heightImage;
  final double spotFontSize;
  final FontWeight spotFontWeight;

  // entry
  final double entryHeightImage;
  final double entryFontSize;
  final double entryIconSize;
  final FontWeight entryFontWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: _parkingRepository.getQrData(uid),
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

            if (snapshot.hasData && snapshot.data!.data() != null) {
              QR qr = QR.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
              );
              // print(doc);
              return StreamBuilder(
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
                  var block = qr.value[0];
                  var spot = qr.value[1];
                  if (data.snapshot.child("$spot/$block/isFilled").value
                          as bool &&
                      qr.outAt == null) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: spotPL,
                        right: spotPR,
                        top: spotPT,
                        bottom: spotPB,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "Your Parking Spot :",
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: fontWeight,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              qr.value,
                              style: TextStyle(
                                color: const Color(0xFFFC1037),
                                fontSize: currentSpotFontSize,
                                fontWeight: currentSpotFontWeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (qr.outAt == null) {
                    var qrNew = QR(
                      uid: qr.uid,
                      value: qr.value,
                      inAt: qr.inAt,
                      outAt: Timestamp.now(),
                    );
                    ParkingRepository().sendQrData(qrNew);
                    return Container();
                  }
                  return Container();
                },
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
                var availableSpots = (data.snapshot.child('1/A/isFilled').value
                            as bool
                        ? 0
                        : 1) +
                    (data.snapshot.child('1/B/isFilled').value as bool
                        ? 0
                        : 1) +
                    (data.snapshot.child('2/A/isFilled').value as bool
                        ? 0
                        : 1) +
                    (data.snapshot.child('2/B/isFilled').value as bool ? 0 : 1);
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: leftAreaFlex,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                height: heightSpot,
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
                                block: "A",
                                spot: "1",
                                data: data.snapshot.child("1/A/isFilled").value
                                    as bool,
                                isLeft: true,
                                height: heightSpot,
                                imageHeight: heightImage,
                                spotFontSize: spotFontSize,
                                spotFontWeight: spotFontWeight,
                              ),
                              ParkingSpot(
                                block: "A",
                                spot: "2",
                                data: data.snapshot.child("2/A/isFilled").value
                                    as bool,
                                isLeft: true,
                                height: heightSpot,
                                imageHeight: heightImage,
                                spotFontSize: spotFontSize,
                                spotFontWeight: spotFontWeight,
                              ),
                              Container(
                                height: heightSpot,
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
                      ),
                      Expanded(
                        flex: centerAreaFlex,
                        child: Center(
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              "${availableSpots.toString()} SLOT FREE",
                              style: TextStyle(
                                fontSize: slotFontSize,
                                fontWeight: slotFontWeight,
                                color: const Color(0xFFE07C8B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: rightAreaFlex,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: heightSpot,
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
                                  block: "B",
                                  spot: "1",
                                  data: data.snapshot
                                      .child("1/B/isFilled")
                                      .value as bool,
                                  isLeft: false,
                                  height: heightSpot,
                                  imageHeight: heightImage,
                                  spotFontSize: spotFontSize,
                                  spotFontWeight: spotFontWeight,
                                ),
                                ParkingSpot(
                                  block: "B",
                                  spot: "2",
                                  data: data.snapshot
                                      .child("2/B/isFilled")
                                      .value as bool,
                                  isLeft: false,
                                  height: heightSpot,
                                  imageHeight: heightImage,
                                  spotFontSize: spotFontSize,
                                  spotFontWeight: spotFontWeight,
                                ),
                                Container(
                                  height: heightSpot,
                                  width: MediaQuery.of(context).size.width,
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: (entryHeightImage + 20),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image(
                          image: const AssetImage("assets/images/car.png"),
                          alignment: Alignment.center,
                          height: entryHeightImage,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.black26,
                    size: entryIconSize,
                  ),
                  Text(
                    "ENTRY",
                    style: TextStyle(
                      fontSize: entryFontSize,
                      fontWeight: entryFontWeight,
                      color: Colors.black26,
                    ),
                  ),
                  // Gap(50),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
