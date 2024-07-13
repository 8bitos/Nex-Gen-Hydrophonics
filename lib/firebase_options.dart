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
    apiKey: 'AIzaSyA5njot_QFeV4MdoCp2SrnJ8V_OIUavrio',
    appId: '1:985311867674:web:ebc8ed10eae1d06afdf2a3',
    messagingSenderId: '985311867674',
    projectId: 'research-nextgenhydroponics',
    authDomain: 'research-nextgenhydroponics.firebaseapp.com',
    databaseURL: 'https://research-nextgenhydroponics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'research-nextgenhydroponics.appspot.com',
    measurementId: 'G-YH8BSRWRJD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP7Ky5iJxnIQDRFxqGInr7_qTB3KYo1iU',
    appId: '1:985311867674:android:a039743a80c78a33fdf2a3',
    messagingSenderId: '985311867674',
    projectId: 'research-nextgenhydroponics',
    databaseURL: 'https://research-nextgenhydroponics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'research-nextgenhydroponics.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtb5JKDhG1tsWsaL5S2I5ykMjARcxBv3Q',
    appId: '1:985311867674:ios:0ea501a7b4912c3bfdf2a3',
    messagingSenderId: '985311867674',
    projectId: 'research-nextgenhydroponics',
    databaseURL: 'https://research-nextgenhydroponics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'research-nextgenhydroponics.appspot.com',
    iosClientId: '985311867674-thq5rb9rum5quq59g7a23tps0pvk0p18.apps.googleusercontent.com',
    iosBundleId: 'com.example.tim1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCtb5JKDhG1tsWsaL5S2I5ykMjARcxBv3Q',
    appId: '1:985311867674:ios:0ea501a7b4912c3bfdf2a3',
    messagingSenderId: '985311867674',
    projectId: 'research-nextgenhydroponics',
    databaseURL: 'https://research-nextgenhydroponics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'research-nextgenhydroponics.appspot.com',
    iosClientId: '985311867674-thq5rb9rum5quq59g7a23tps0pvk0p18.apps.googleusercontent.com',
    iosBundleId: 'com.example.tim1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5njot_QFeV4MdoCp2SrnJ8V_OIUavrio',
    appId: '1:985311867674:web:3d9dcd98f9216432fdf2a3',
    messagingSenderId: '985311867674',
    projectId: 'research-nextgenhydroponics',
    authDomain: 'research-nextgenhydroponics.firebaseapp.com',
    databaseURL: 'https://research-nextgenhydroponics-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'research-nextgenhydroponics.appspot.com',
    measurementId: 'G-XV7QRLP9JC',
  );
}
