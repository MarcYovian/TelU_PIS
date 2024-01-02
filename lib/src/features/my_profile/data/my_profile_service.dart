import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileService {
  // get instance firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get instance auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get profile data
  Stream<DocumentSnapshot> getProfileData() {
    return _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }
}
