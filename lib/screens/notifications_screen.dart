import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Notifications',
      showBack: true,
      showBell: false,
      body: LoadingGate(
        child: ListenableBuilder(
          listenable: AppState.i,
          builder: (context, _) {
            return PageList(
              children: [
                ChipRow(
                  items: const [
                    'All',
                    'Emergency',
                    'Verification',
                    'Inventory',
                    'System',
                  ],
                  current: _filter,
                  onPick: (v) => setState(() => _filter = v),
                ),
                AppButton(
                  'Mark all as read',
                  kind: BtnKind.outline,
                  onPressed: AppState.i.markAllRead,
                ),
                for (var i = 0; i < kNotifications.length; i++)
                  if (_filter == 'All' || kNotifications[i].category == _filter)
                    AppCard(
                      onTap: () => AppState.i.markRead(i),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppState.i.read.contains(i)
                                  ? Colors.transparent
                                  : C.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(kNotifications[i].title, style: T.title),
                                Text(kNotifications[i].message, style: T.sub),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          StatusBadge(
                            kNotifications[i].category,
                            tone: kNotifications[i].category == 'Emergency'
                                ? Tone.bad
                                : Tone.n,
                          ),
                        ],
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
