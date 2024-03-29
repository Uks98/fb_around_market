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
    apiKey: 'AIzaSyAjmW-LuFp779s0Nsh-l18BAn_Q6ZmwaA4',
    appId: '1:567948579243:web:8a4465b8c875aee53242ee',
    messagingSenderId: '567948579243',
    projectId: 'fbaroundmarket',
    authDomain: 'fbaroundmarket.firebaseapp.com',
    storageBucket: 'fbaroundmarket.appspot.com',
    measurementId: 'G-FKZJQSFTKC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMXPydsQl4sgaTKKCokQkKdl9J4U1JQt0',
    appId: '1:567948579243:android:fc8afac3b96aefbc3242ee',
    messagingSenderId: '567948579243',
    projectId: 'fbaroundmarket',
    storageBucket: 'fbaroundmarket.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4DwR4rm_KJhLOuy2y8fOhnODkEs8vsDs',
    appId: '1:567948579243:ios:09513209af3ea4683242ee',
    messagingSenderId: '567948579243',
    projectId: 'fbaroundmarket',
    storageBucket: 'fbaroundmarket.appspot.com',
    androidClientId: '567948579243-c82mh34i1trlbm8rmeb6nrbapmkthkuv.apps.googleusercontent.com',
    iosClientId: '567948579243-f6qpb4oqvqpq22p2t6qp1gojriq7qrfj.apps.googleusercontent.com',
    iosBundleId: 'com.example.fbAroundMarket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4DwR4rm_KJhLOuy2y8fOhnODkEs8vsDs',
    appId: '1:567948579243:ios:614b7d48f619bb2a3242ee',
    messagingSenderId: '567948579243',
    projectId: 'fbaroundmarket',
    storageBucket: 'fbaroundmarket.appspot.com',
    androidClientId: '567948579243-c82mh34i1trlbm8rmeb6nrbapmkthkuv.apps.googleusercontent.com',
    iosClientId: '567948579243-crthplm3u6ct76nk16abqgo3kibms2of.apps.googleusercontent.com',
    iosBundleId: 'com.example.fbAroundMarket.RunnerTests',
  );
}
