import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'home_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: spaced([
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: C.red,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin Login', style: T.big),
                    SizedBox(height: 4),
                    Text(
                      'Online Blood Donation Management System',
                      style: T.sub,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: C.track,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 20, color: C.navy),
                      const SizedBox(width: 10),
                      Text(
                        'Secure administrator access only',
                        style: T.sub.copyWith(color: C.navy),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: T.sub.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: 'admin@bloodlink.pk',
                      keyboardType: TextInputType.emailAddress,
                      decoration: appInput(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: T.sub.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: 'password123',
                      obscureText: true,
                      decoration: appInput(),
                    ),
                  ],
                ),
                AppButton(
                  'Login',
                  onPressed: () {
                    AppState.i.reset();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                    );
                  },
                ),
                AppButton(
                  'Forgot Password?',
                  kind: BtnKind.plain,
                  onPressed: () =>
                      showToast(context, 'Reset link sent to admin email.'),
                ),
              ], gap: 18),
            ),
          ),
        ),
      ),
    );
  }
}
