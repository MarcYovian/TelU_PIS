import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:parking_v3/src/features/profile/domain/profile.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign user in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // sign in;
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
      Profile profile, String password) async {
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: profile.email,
        password: password,
      );

      // create a new document for the user in the user collection
      _firestore
          .collection('Users')
          .doc(credential.user!.uid)
          .set(profile.toMap());
      return credential;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
