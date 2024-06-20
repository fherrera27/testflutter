import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDfVynrH8GgpdaJZCSOQ8n2w_L8KDWrVVE",
            authDomain: "birthday-oe5ij0.firebaseapp.com",
            projectId: "birthday-oe5ij0",
            storageBucket: "birthday-oe5ij0.appspot.com",
            messagingSenderId: "70989939812",
            appId: "1:70989939812:web:6f64f58e93789030da8b71"));
  } else {
    await Firebase.initializeApp();
  }
}
