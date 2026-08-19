// Generated from the Firebase Android app configuration for WK Cliente.
// Keep this file in sync with the Firebase project `app-wk`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase options for web are not configured for this Android MVP.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase options are currently configured only for Android.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Firebase is not configured for Fuchsia.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp-o4S8Atgwud68gmXM3dYMKKr9rs0Ha4',
    appId: '1:818781431862:android:164597f939824efb09d097',
    messagingSenderId: '818781431862',
    projectId: 'app-wk',
    storageBucket: 'app-wk.firebasestorage.app',
  );
}
