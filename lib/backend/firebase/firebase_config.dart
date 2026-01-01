import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2HGUJANgClgL1Vkfo08CU5h2I3NWvi_c",
            authDomain: "eatwise-39b38.firebaseapp.com",
            projectId: "eatwise-39b38",
            storageBucket: "eatwise-39b38.firebasestorage.app",
            messagingSenderId: "1020187359282",
            appId: "1:1020187359282:web:83383eebbdbcf646b4642b"));
  } else {
    await Firebase.initializeApp();
  }
}
