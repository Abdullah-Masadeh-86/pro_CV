import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    authDomain: 'cv-project-adc4b.firebaseapp.com',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
    measurementId: 'G-XJD2W3SWZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
    iosBundleId: 'com.cvapp.cvFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
    iosBundleId: 'com.cvapp.cvFlutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBdPPu-MQfDEKME7TasLKnQcEzaYI5xRl8',
    appId: '1:1038009858795:web:7da143f3cebf01f8ea9cae',
    messagingSenderId: '1038009858795',
    projectId: 'cv-project-adc4b',
    storageBucket: 'cv-project-adc4b.firebasestorage.app',
  );
}
