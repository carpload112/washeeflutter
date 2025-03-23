import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD97b2tl3PQU0PcIoOT-TCYOwG0V_x7ZHM',
    appId: '1:1010656295261:android:d81780eeefbaa90cd610b4',
    messagingSenderId: '1010656295261',
    projectId: 'the-washee-fac0e',
    databaseURL: 'https://the-washee-fac0e-default-rtdb.firebaseio.com',
    storageBucket: 'the-washee-fac0e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq-PNvKwplJpqhenN9JYeqc2NIvywS2iA',
    appId: '1:1010656295261:ios:4c1ba47208fa005bd610b4',
    messagingSenderId: '1010656295261',
    projectId: 'the-washee-fac0e',
    databaseURL: 'https://the-washee-fac0e-default-rtdb.firebaseio.com',
    storageBucket: 'the-washee-fac0e.firebasestorage.app',
    iosClientId: '1010656295261-1dkbil2ma58hosoe0m4152lsp3of62qs.apps.googleusercontent.com',
    iosBundleId: 'com.flutterflow.homeU',
  );
}

