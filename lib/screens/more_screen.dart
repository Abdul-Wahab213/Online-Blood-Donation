import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import 'donations_screen.dart';
import 'inventory_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'verification_screens.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void push(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    final items = <(String, String, IconData, VoidCallback)>[
      (
        'Donor Verification',
        'Review pending donors',
        Icons.check,
        () => push(const VerificationScreen(isDonor: true)),
      ),
      (
        'Hospital Verification',
        'Review pending hospitals',
        Icons.local_hospital_outlined,
        () => push(
          const VerificationScreen(isDonor: false, orgType: 'Hospitals'),
        ),
      ),
      (
        'Blood Bank Verification',
        'Review pending blood banks',
        Icons.account_balance_outlined,
        () => push(
          const VerificationScreen(isDonor: false, orgType: 'Blood Banks'),
        ),
      ),
      (
        'Blood Inventory',
        'Stock by blood group',
        Icons.water_drop_outlined,
        () => push(const InventoryScreen()),
      ),
      (
        'Donations',
        'Scheduled & completed',
        Icons.favorite_border,
        () => push(const DonationsScreen()),
      ),
      (
        'Notifications',
        'Alerts and updates',
        Icons.notifications_none,
        () => push(const NotificationsScreen()),
      ),
      (
        'Admin Profile',
        'Account and password',
        Icons.person_outline,
        () => push(const ProfileScreen()),
      ),
      (
        'Settings',
        'Preview loading and error states',
        Icons.settings_outlined,
        () => push(const SettingsScreen()),
      ),
      (
        'Logout',
        'Sign out securely',
        Icons.logout,
        () {
          AppState.i.reset();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (r) => false,
          );
        },
      ),
    ];

    return AdminScaffold(
      title: 'More',
      body: LoadingGate(
        child: PageList(
          children: [
            for (final it in items)
              AppCard(
                onTap: it.$4,
                child: Row(
                  children: [
                    Icon(it.$3, color: C.navy),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.$1, style: T.title),
                          Text(it.$2, style: T.sub),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
