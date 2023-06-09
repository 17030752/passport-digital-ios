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
    apiKey: 'AIzaSyBrAHIjPswFQ88XpFRgVIC3HIX-zlyvYPg',
    appId: '1:802584364605:web:df28ec23df12845d0a4c54',
    messagingSenderId: '802584364605',
    projectId: 'passport-digital-itc',
    authDomain: 'passport-digital-itc.firebaseapp.com',
    storageBucket: 'passport-digital-itc.appspot.com',
    measurementId: 'G-SP08YWNJCW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWijjMIYElDRKiFsGqWfPtZ_2b1k-aCT4',
    appId: '1:802584364605:android:d5db36b556026a770a4c54',
    messagingSenderId: '802584364605',
    projectId: 'passport-digital-itc',
    storageBucket: 'passport-digital-itc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-ZczLTaLsKICxB8WMf0DuDYw7ipHn-Rk',
    appId: '1:802584364605:ios:a2fec780517ee5600a4c54',
    messagingSenderId: '802584364605',
    projectId: 'passport-digital-itc',
    storageBucket: 'passport-digital-itc.appspot.com',
    iosClientId: '802584364605-ai9bntbq8peuf1q8nd9ofkmm81s06rrh.apps.googleusercontent.com',
    iosBundleId: 'com.example.passportDigitalItc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-ZczLTaLsKICxB8WMf0DuDYw7ipHn-Rk',
    appId: '1:802584364605:ios:a2fec780517ee5600a4c54',
    messagingSenderId: '802584364605',
    projectId: 'passport-digital-itc',
    storageBucket: 'passport-digital-itc.appspot.com',
    iosClientId: '802584364605-ai9bntbq8peuf1q8nd9ofkmm81s06rrh.apps.googleusercontent.com',
    iosBundleId: 'com.example.passportDigitalItc',
  );
}
