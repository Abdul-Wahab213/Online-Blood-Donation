import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import 'request_details_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _filter = 'All';
  String _q = '';

  static const _filters = [
    'All',
    'O+',
    'O-',
    'A-',
    'B+',
    'AB+',
    'Emergency',
    'Urgent',
    'Normal',
    'Pending',
    'Accepted',
    'Completed',
    'Islamabad',
    'Rawalpindi',
    'Today',
  ];

  bool _match(BloodRequest r) {
    final f = _filter;
    final byFilter =
        f == 'All' ||
        r.group == f ||
        r.priority == f ||
        r.status == f ||
        r.location == f ||
        (f == 'Today' && r.date == '05 Oct 2026');
    final hay = (r.id + r.patient + r.hospital).toLowerCase();
    return byFilter && (_q.isEmpty || hay.contains(_q.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    final list = kRequests.where(_match).toList();
    void open(BloodRequest r) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RequestDetailsScreen(requestId: r.id)),
    );

    return AdminScaffold(
      title: 'Blood Requests',
      body: LoadingGate(
        child: PageList(
          children: [
            SearchField(
              hint: 'Search request...',
              onChanged: (v) => setState(() => _q = v),
            ),
            ChipRow(
              items: _filters,
              current: _filter,
              onPick: (v) => setState(() => _filter = v),
            ),
            for (final r in list)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BloodBox(r.group),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${r.id} · ${r.patient}', style: T.title),
                              Text(
                                '${r.units} units · ${r.hospital} · ${r.date}',
                                style: T.sub,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusBadge(r.priority),
                        const SizedBox(width: 8),
                        StatusBadge(r.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            'View',
                            kind: BtnKind.outline,
                            compact: true,
                            onPressed: () => open(r),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            'Assign Donor',
                            compact: true,
                            onPressed: () => open(r),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            'Update Status',
                            kind: BtnKind.outline,
                            compact: true,
                            onPressed: () =>
                                showToast(context, 'Blood request updated.'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (list.isEmpty)
              const EmptyCard(
                'No blood requests',
                'New requests will appear here.',
              ),
          ],
        ),
      ),
    );
  }
}
