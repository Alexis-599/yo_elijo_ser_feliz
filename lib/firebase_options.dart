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
    apiKey: 'AIzaSyBn0_R3mF5J1Xx7LYD7pMhdoCgvz-RNZMQ',
    appId: '1:673696485534:web:dba29eafbc7975fda1ab8f',
    messagingSenderId: '673696485534',
    projectId: 'podcasts-yo-elijo-ser-feliz',
    authDomain: 'podcasts-yo-elijo-ser-feliz.firebaseapp.com',
    storageBucket: 'podcasts-yo-elijo-ser-feliz.appspot.com',
    measurementId: 'G-94ZJQ7JK0R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkLezImcsSOnjPTab6TUUwOAY6GvoO8Lo',
    appId: '1:673696485534:android:1ac31e3fe729e9aea1ab8f',
    messagingSenderId: '673696485534',
    projectId: 'podcasts-yo-elijo-ser-feliz',
    storageBucket: 'podcasts-yo-elijo-ser-feliz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCThNjrESvKYMQGM7XkyoO50UZFWwG2y3g',
    appId: '1:673696485534:ios:579ae9ead7ecd3a9a1ab8f',
    messagingSenderId: '673696485534',
    projectId: 'podcasts-yo-elijo-ser-feliz',
    storageBucket: 'podcasts-yo-elijo-ser-feliz.appspot.com',
    iosClientId: '673696485534-vuc42s3lj34rn0bcp8qqa8urpurnv1nk.apps.googleusercontent.com',
    iosBundleId: 'com.example.podcastsRuben',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCThNjrESvKYMQGM7XkyoO50UZFWwG2y3g',
    appId: '1:673696485534:ios:579ae9ead7ecd3a9a1ab8f',
    messagingSenderId: '673696485534',
    projectId: 'podcasts-yo-elijo-ser-feliz',
    storageBucket: 'podcasts-yo-elijo-ser-feliz.appspot.com',
    iosClientId: '673696485534-vuc42s3lj34rn0bcp8qqa8urpurnv1nk.apps.googleusercontent.com',
    iosBundleId: 'com.example.podcastsRuben',
  );
}
