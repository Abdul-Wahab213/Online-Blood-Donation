import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation Admin',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const LoginScreen(),
    );
  }
}
