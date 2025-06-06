// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCv8ri40Uk1FYYCUymOaGxcA95voJpNtSY',
    appId: '1:840088402412:web:1a7207f25294e89258e8c9',
    messagingSenderId: '840088402412',
    projectId: 'focusfortress-339a9',
    authDomain: 'focusfortress-339a9.firebaseapp.com',
    storageBucket: 'focusfortress-339a9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfK918Ke41-yMGZdNLIpPVftJgFT3xPoE',
    appId: '1:840088402412:android:1162df215ee00a5758e8c9',
    messagingSenderId: '840088402412',
    projectId: 'focusfortress-339a9',
    storageBucket: 'focusfortress-339a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArZLF-6gIDS-ue6Y0iOtXEAYiZCPCHeU4',
    appId: '1:840088402412:ios:9c1744128e2522cd58e8c9',
    messagingSenderId: '840088402412',
    projectId: 'focusfortress-339a9',
    storageBucket: 'focusfortress-339a9.appspot.com',
    iosBundleId: 'com.focusfortress.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArZLF-6gIDS-ue6Y0iOtXEAYiZCPCHeU4',
    appId: '1:840088402412:ios:9c1744128e2522cd58e8c9',
    messagingSenderId: '840088402412',
    projectId: 'focusfortress-339a9',
    storageBucket: 'focusfortress-339a9.appspot.com',
    iosBundleId: 'com.focusfortress.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv8ri40Uk1FYYCUymOaGxcA95voJpNtSY',
    appId: '1:840088402412:web:cf585b42a3ba627e58e8c9',
    messagingSenderId: '840088402412',
    projectId: 'focusfortress-339a9',
    authDomain: 'focusfortress-339a9.firebaseapp.com',
    storageBucket: 'focusfortress-339a9.appspot.com',
  );
}
