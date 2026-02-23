import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'auth/admin_auth_gate.dart';
import 'theme/admin_theme.dart';

/// Main entry point for admin web panel
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatWise Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.themeData,
      home: const AdminAuthGate(),
    );
  }
}
