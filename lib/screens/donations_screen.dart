import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';

class DonationsScreen extends StatefulWidget {
  final String initialFilter;
  const DonationsScreen({super.key, this.initialFilter = 'All'});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  late String _filter = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    final list = kDonations
        .where((d) => _filter == 'All' || d.status == _filter)
        .toList();
    return AdminScaffold(
      title: 'Donations',
      showBack: true,
      body: LoadingGate(
        child: PageList(
          children: [
            ChipRow(
              items: const ['All', 'Scheduled', 'Completed', 'Cancelled'],
              current: _filter,
              onPick: (v) => setState(() => _filter = v),
            ),
            for (final d in list)
              AppCard(
                child: Row(
                  children: [
                    BloodBox(d.group),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${d.id} · ${d.name}', style: T.title),
                          Text(
                            '${d.hospital} · ${d.date} · ${d.units} unit(s)',
                            style: T.sub,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusBadge(d.status),
                  ],
                ),
              ),
            if (list.isEmpty)
              const EmptyCard('No donations', 'No donations recorded yet.'),
          ],
        ),
      ),
    );
  }
}
