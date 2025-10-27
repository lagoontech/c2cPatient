import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return _androidOptions;
    } else if (Platform.isIOS) {
      return _iosOptions;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }

  static const FirebaseOptions _androidOptions = FirebaseOptions(
    apiKey: 'AIzaSyBFzoMa0Qn3hH_WFT2qhcmnJ_cWN5GmjVM',
    appId: '1:496441455277:android:8e8e837b4dbe07d1774c24', // Matches com.care2care.patient
    messagingSenderId: '496441455277',
    projectId: 'c2cpatient-d4526',
    storageBucket: 'c2cpatient-d4526.appspot.com', // Correct bucket for Firebase
  );

  static const FirebaseOptions _iosOptions = FirebaseOptions(
    apiKey: 'AIzaSyARzj9bC7XvdxuxKDW2-mdnhpRpzoXwxnQ', // Update if needed
    appId: '1:496441455277:ios:7534e179dd8d22ca774c24',
    messagingSenderId: '496441455277',
    projectId: 'c2cpatient-d4526',
    storageBucket: 'c2cpatient-d4526.appspot.com',
    iosBundleId: 'com.example.care2care',
  );
}
