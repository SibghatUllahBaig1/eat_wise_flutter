import 'package:firebase_core/firebase_core.dart';

import '/firebase_options.dart';

Future initFirebase() async {
  // Always pass explicit options so release/ad-hoc IPAs work even if the
  // bundled GoogleService-Info.plist is missing or out of sync.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
