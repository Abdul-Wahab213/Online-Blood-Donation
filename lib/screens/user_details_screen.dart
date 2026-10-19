import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final u = kUsers.firstWhere((x) => x.id == userId);
    return AdminScaffold(
      title: 'User Details',
      showBack: true,
      body: LoadingGate(
        child: ListenableBuilder(
          listenable: AppState.i,
          builder: (context, _) {
            final suspended = AppState.i.isSuspended(u.id);
            return PageList(
              children: [
                AppCard(
                  child: Column(
                    children: [
                      Avatar(u.initials, size: 64),
                      const SizedBox(height: 8),
                      Text(u.name, style: T.h),
                      Text('${u.id} · ${u.role}', style: T.sub),
                      const SizedBox(height: 6),
                      StatusBadge(suspended ? 'Suspended' : 'Active'),
                    ],
                  ),
                ),
                AppCard(
                  child: Column(
                    children: [
                      KvRow('Email', u.email),
                      KvRow('Phone', u.phone),
                      KvRow('Location', u.loc),
                      KvRow('Registered', u.reg),
                      KvRow(u.k1, u.v1),
                      KvRow(u.k2, u.v2),
                      KvRow(u.k3, u.v3, last: true),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        'Verify',
                        kind: BtnKind.success,
                        onPressed: () => showToast(
                          context,
                          u.role == 'Donor'
                              ? 'Donor verified successfully.'
                              : 'Account verified successfully.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        'Edit',
                        kind: BtnKind.outline,
                        onPressed: () =>
                            showToast(context, 'Edit form opens here.'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        suspended ? 'Activate' : 'Suspend',
                        kind: suspended ? BtnKind.primary : BtnKind.danger,
                        onPressed: () => runSuspendFlow(context, u.id),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
