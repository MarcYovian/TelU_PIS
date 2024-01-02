// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBr0-OoY6Ze6jJOX06tparJuBlD_tv0_sQ',
    appId: '1:680719267065:web:99a4d5324269f5f5fdde28',
    messagingSenderId: '680719267065',
    projectId: 'parkingiot-6568d',
    authDomain: 'parkingiot-6568d.firebaseapp.com',
    databaseURL: 'https://parkingiot-6568d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'parkingiot-6568d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGUjuZt9rSMoIGzHwBs0gvppSklMeq5IE',
    appId: '1:680719267065:android:37b8b89519fe3aabfdde28',
    messagingSenderId: '680719267065',
    projectId: 'parkingiot-6568d',
    databaseURL: 'https://parkingiot-6568d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'parkingiot-6568d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDg4AYFI3X4EKsYqWXWH7f6kqoFDR_IC0',
    appId: '1:680719267065:ios:3e6e9e7c44c793dafdde28',
    messagingSenderId: '680719267065',
    projectId: 'parkingiot-6568d',
    databaseURL: 'https://parkingiot-6568d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'parkingiot-6568d.appspot.com',
    iosBundleId: 'com.example.parkingV3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDg4AYFI3X4EKsYqWXWH7f6kqoFDR_IC0',
    appId: '1:680719267065:ios:576f7c19bc7e4b05fdde28',
    messagingSenderId: '680719267065',
    projectId: 'parkingiot-6568d',
    databaseURL: 'https://parkingiot-6568d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'parkingiot-6568d.appspot.com',
    iosBundleId: 'com.example.parkingV3.RunnerTests',
  );
}