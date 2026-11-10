// Exemplo de firebase_options.dart (sem chaves reais).
// O arquivo real é gerado pelo FlutterFire CLI e fica fora do Git.
// Na CI, este exemplo é copiado para firebase_options.dart apenas para compilar.
// ignore_for_file: type=lint
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUA-API-KEY',
    appId: 'SEU-APP-ID',
    messagingSenderId: 'SEU-SENDER-ID',
    projectId: 'seu-projeto',
    authDomain: 'seu-projeto.firebaseapp.com',
    storageBucket: 'seu-projeto.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'SUA-API-KEY',
    appId: 'SEU-APP-ID',
    messagingSenderId: 'SEU-SENDER-ID',
    projectId: 'seu-projeto',
    storageBucket: 'seu-projeto.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'SUA-API-KEY',
    appId: 'SEU-APP-ID',
    messagingSenderId: 'SEU-SENDER-ID',
    projectId: 'seu-projeto',
    storageBucket: 'seu-projeto.appspot.com',
    iosBundleId: 'com.exemplo.clickboard',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = web;
}
