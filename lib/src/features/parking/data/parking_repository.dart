import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_v3/src/features/parking/domain/qr.dart';

class ParkingRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get all parking data
  Stream<DatabaseEvent> getDataParking() {
    return _database.ref("smart_parking/blocks").onValue;
  }

  // get user data
  Stream<DocumentSnapshot> getUserData() {
    final currentUser = _auth.currentUser!.uid;

    return _firestore.collection('Users').doc(currentUser).snapshots();
  }

  // send qr data
  Future<void> sendQrData(QR qr) async {
    await _firestore
        .collection("logs")
        .doc(_auth.currentUser!.uid)
        .set(qr.toMap());
  }

  // get qr data
  Stream<DocumentSnapshot> getQrData(String uid) {
    return _firestore.collection("logs").doc(uid).snapshots();
  }
}
