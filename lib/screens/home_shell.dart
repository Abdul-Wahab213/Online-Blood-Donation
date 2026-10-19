import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'dashboard_screen.dart';
import 'users_screen.dart';
import 'requests_screen.dart';
import 'reports_screen.dart';
import 'more_screen.dart';

/// Switches between the 5 bottom-navigation tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.i,
      builder: (context, _) {
        final t = AppState.i.tab;
        final Widget page;
        switch (t) {
          case 1:
            page = const UsersScreen();
            break;
          case 2:
            page = const RequestsScreen();
            break;
          case 3:
            page = const ReportsScreen();
            break;
          case 4:
            page = const MoreScreen();
            break;
          default:
            page = const DashboardScreen();
        }
        return KeyedSubtree(key: ValueKey(t), child: page);
      },
    );
  }
}
