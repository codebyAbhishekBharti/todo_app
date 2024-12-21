// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart`
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
    apiKey: 'AIzaSyD_gPGdop-ECO1wpp4mkdcsmf6HZ4Va8lQ',
    appId: '1:122887292381:web:6bbcfe82d2982ff3c6e234',
    messagingSenderId: '122887292381',
    projectId: 'todo-with-sync',
    authDomain: 'todo-with-sync.firebaseapp.com',
    storageBucket: 'todo-with-sync.appspot.com',
    measurementId: 'G-D9JM1M2633',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDN6v7po6qZ651YLzx5EErKv4W4ZIcSuCA',
    appId: '1:122887292381:android:80c51a77e71c31c6c6e234',
    messagingSenderId: '122887292381',
    projectId: 'todo-with-sync',
    storageBucket: 'todo-with-sync.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCukQEXm8iQqQYH1hrnYxaq11n1jt8op6w',
    appId: '1:122887292381:ios:acfd4a682ab00616c6e234',
    messagingSenderId: '122887292381',
    projectId: 'todo-with-sync',
    storageBucket: 'todo-with-sync.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCukQEXm8iQqQYH1hrnYxaq11n1jt8op6w',
    appId: '1:122887292381:ios:acfd4a682ab00616c6e234',
    messagingSenderId: '122887292381',
    projectId: 'todo-with-sync',
    storageBucket: 'todo-with-sync.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD_gPGdop-ECO1wpp4mkdcsmf6HZ4Va8lQ',
    appId: '1:122887292381:web:3a74d611fb6297f7c6e234',
    messagingSenderId: '122887292381',
    projectId: 'todo-with-sync',
    authDomain: 'todo-with-sync.firebaseapp.com',
    storageBucket: 'todo-with-sync.appspot.com',
    measurementId: 'G-13E2HZ9XKG',
  );
}
