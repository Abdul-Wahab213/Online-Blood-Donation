import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Settings',
      showBack: true,
      body: PageList(
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('State previews', style: T.title),
                Text(
                  'Open the loading and error pages from here.',
                  style: T.sub,
                ),
              ],
            ),
          ),
          AppButton(
            'Preview loading state',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AdminScaffold(
                    title: 'Manage Users',
                    showBack: true,
                    body: LoadingGate(
                      ms: 2500,
                      child: Center(child: Text('Loaded', style: T.h)),
                    ),
                  ),
                ),
              );
            },
          ),
          AppButton(
            'Preview error state',
            kind: BtnKind.outline,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AdminScaffold(
                    title: 'Error',
                    showBack: true,
                    body: ErrorStateView(
                      onRetry: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
