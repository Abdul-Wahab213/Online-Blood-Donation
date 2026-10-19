import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBack;
  final bool showMenu;
  final bool showNav;
  final bool showBell;
  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBack = false,
    this.showMenu = false,
    this.showNav = true,
    this.showBell = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 56,
        leading: showBack
            ? IconButton(
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : showMenu
            ? IconButton(
                tooltip: 'Profile',
                icon: const Icon(Icons.menu),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [if (showBell) const _Bell()],
      ),
      body: SafeArea(top: false, bottom: !showNav, child: body),
      bottomNavigationBar: showNav ? const AdminBottomNav() : null,
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.i,
      builder: (context, _) {
        final n = AppState.i.unreadCount;
        return IconButton(
          tooltip: 'Notifications',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none),
              if (n > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: C.redBright,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '$n',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({super.key});

  static const _labels = ['Dashboard', 'Users', 'Requests', 'Reports', 'More'];
  static const _icons = [
    Icons.home_outlined,
    Icons.people_outline,
    Icons.water_drop_outlined,
    Icons.bar_chart,
    Icons.menu,
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.i,
      builder: (context, _) {
        final current = AppState.i.tab;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: C.border)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                for (var i = 0; i < 5; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        AppState.i.openTab(i);
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      },
                      child: SizedBox(
                        height: 56,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _icons[i],
                              size: 22,
                              color: i == current ? C.red : C.sub,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _labels[i],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: i == current
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: i == current ? C.red : C.sub,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
