import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options for project `reef-2158c`.
///
/// Generated from `android/app/google-services.json` and
/// `ios/Runner/GoogleService-Info.plist`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCm7t-WqkBnr-saIdZHkL0TKGmF_2PcARA',
    appId: '1:325145915220:android:ef5ccd9210dd94bc8862c1',
    messagingSenderId: '325145915220',
    projectId: 'reef-2158c',
    storageBucket: 'reef-2158c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4aZDi7u7SarI_uCKiYVkwsOYn1B6XLEI',
    appId: '1:325145915220:ios:58d0da0ad14eae118862c1',
    messagingSenderId: '325145915220',
    projectId: 'reef-2158c',
    storageBucket: 'reef-2158c.firebasestorage.app',
    iosBundleId: 'com.reefSaudi',
  );
}
