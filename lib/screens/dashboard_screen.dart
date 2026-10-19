import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';
import 'donations_screen.dart';
import 'inventory_screen.dart';
import 'request_details_screen.dart';

class _Stat {
  final String label, value, sub, tag;
  final IconData icon;
  final Tone tone;
  final VoidCallback onTap;
  _Stat(
    this.label,
    this.value,
    this.sub,
    this.icon,
    this.tag,
    this.tone,
    this.onTap,
  );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _range = 'Today';

  @override
  Widget build(BuildContext context) {
    void push(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    final stats = <_Stat>[
      _Stat(
        'Total Donors',
        '2,458',
        '+12.4% this month',
        Icons.person_outline,
        '▲ 12.4%',
        Tone.ok,
        () => AppState.i.openTab(1, filter: 'Donors'),
      ),
      _Stat(
        'Total Patients',
        '1,284',
        '+8.2% this month',
        Icons.favorite_border,
        '▲ 8.2%',
        Tone.ok,
        () => AppState.i.openTab(1, filter: 'Patients'),
      ),
      _Stat(
        'Total Requests',
        '846',
        '124 pending',
        Icons.assignment_outlined,
        '124 pending',
        Tone.warn,
        () => AppState.i.openTab(2),
      ),
      _Stat(
        'Successful Donations',
        '632',
        'Completed',
        Icons.check_circle_outline,
        '▲ 15.6%',
        Tone.ok,
        () => push(const DonationsScreen(initialFilter: 'Completed')),
      ),
      _Stat(
        'Blood Inventory',
        '4,820 Units',
        'Available stock',
        Icons.water_drop_outlined,
        'Stock',
        Tone.n,
        () => push(const InventoryScreen()),
      ),
      _Stat(
        'Active Users',
        '1,936',
        'Currently active',
        Icons.bar_chart,
        'Live',
        Tone.n,
        () => AppState.i.openTab(1, filter: 'Active'),
      ),
    ];

    return AdminScaffold(
      title: 'Admin Dashboard',
      showMenu: true,
      body: LoadingGate(
        dashboard: true,
        child: PageList(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning, Admin', style: T.big),
                Text("Here's today's system overview", style: T.sub),
              ],
            ),
            ChipRow(
              items: const ['Today', 'This Week', 'This Month', 'This Year'],
              current: _range,
              onPick: (v) => setState(() => _range = v),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: [for (final s in stats) _StatCard(s)],
            ),
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Blood Inventory', style: T.h),
                      FilterPill(
                        'View Inventory',
                        false,
                        () => push(const InventoryScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const InventoryBars(),
                ],
              ),
            ),
            const TrendBarsCard(
              title: 'Monthly Donations',
              subtitle: 'Total 4,015 · Avg 502/mo · ▲ 15.6%',
              showValues: true,
            ),
            const DistributionCard(),
            const RequestsTrendCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Blood Requests', style: T.h),
                FilterPill(
                  'View All Requests',
                  false,
                  () => AppState.i.openTab(2),
                ),
              ],
            ),
            for (final q in kRequests.take(3))
              AppCard(
                child: Row(
                  children: [
                    BloodBox(q.group),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${q.id} · ${q.patient}', style: T.title),
                          Text(
                            '${q.units} units · ${q.hospital}',
                            style: T.sub,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              StatusBadge(q.priority),
                              const SizedBox(width: 8),
                              StatusBadge(q.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FilterPill(
                      'View',
                      false,
                      () => push(RequestDetailsScreen(requestId: q.id)),
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

class _StatCard extends StatelessWidget {
  final _Stat s;
  const _StatCard(this.s);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: s.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(s.icon, size: 22, color: C.navy),
              Flexible(child: StatusBadge(s.tag, tone: s.tone)),
            ],
          ),
          const SizedBox(height: 6),
          Text(s.value, style: T.value),
          Text(
            s.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: C.ink,
            ),
          ),
          Text(s.sub, style: T.sub),
        ],
      ),
    );
  }
}
