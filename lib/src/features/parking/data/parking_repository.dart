import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
}
