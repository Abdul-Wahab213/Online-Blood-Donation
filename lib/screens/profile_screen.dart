import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Admin Profile',
      showBack: true,
      body: LoadingGate(
        child: PageList(
          children: [
            const AppCard(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Avatar('SA', size: 72),
                  SizedBox(height: 8),
                  Text('Sana Ahmed', style: T.h),
                  SizedBox(height: 2),
                  Text(
                    'admin@bloodlink.pk · Super Admin · +92 51 1234567',
                    textAlign: TextAlign.center,
                    style: T.sub,
                  ),
                ],
              ),
            ),
            AppButton(
              'Edit Profile',
              kind: BtnKind.outline,
              onPressed: () => showToast(context, 'Edit form opens here.'),
            ),
            AppButton(
              'Change Password',
              kind: BtnKind.outline,
              onPressed: () => showToast(context, 'Edit form opens here.'),
            ),
            AppButton(
              'Notification Settings',
              kind: BtnKind.outline,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            AppButton(
              'Logout',
              kind: BtnKind.danger,
              onPressed: () {
                AppState.i.reset();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (r) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
