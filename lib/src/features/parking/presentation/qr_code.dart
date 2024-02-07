import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/parking/data/parking_repository.dart';
import 'package:parking_v3/src/features/parking/domain/qr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "SCAN QR NOW",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )),
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color(0xFFEDF7F9),
                          ),
                        ),
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Text(
                              'Flash: ${snapshot.data}',
                              style: const TextStyle(
                                color: Color(0xff0A1D81),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Center(
                          child: (result != null)
                              ? Text("Value : ${result!.code!}")
                              : const Text("Value :"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color(0xFFEDF7F9),
                            ),
                          ),
                          onPressed: () async {
                            var code = result!.code.toString();
                            if (code.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Scan QR Code"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            if (code == "A1" ||
                                code == "A2" ||
                                code == "B1" ||
                                code == "B2") {
                              QR qr = QR(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                value: result!.code!,
                                inAt: Timestamp.now(),
                                outAt: null,
                              );

                              if (await controller!.getFlashStatus() == true) {
                                controller!.toggleFlash();
                              }

                              ParkingRepository().sendQrData(qr);
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, parkingScreen);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Code not match"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0A1D81),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('no Permission'),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget hasResult() {
    // print(result!.code! ?? null);

    if (result == null) {
      return const Text('Scan a code');
    }

    if (result!.code == "A1" ||
        result!.code == "A2" ||
        result!.code == "B1" ||
        result!.code == "B2") {
      QR qr = QR(
        uid: FirebaseAuth.instance.currentUser!.uid,
        value: result!.code!,
        inAt: Timestamp.now(),
        outAt: null,
      );

      ParkingRepository().sendQrData(qr);
      Navigator.pushNamed(context, parkingScreen);

      return Text("${result!.code}");
    }

    return const Text("Code not found");
  }
}
