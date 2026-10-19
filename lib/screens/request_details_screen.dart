import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;
  const RequestDetailsScreen({super.key, required this.requestId});

  static const _timeline = [
    ['Request Created', 'Done', 0xFF2E7D4F],
    ['Donor Matched', 'Done', 0xFF2E7D4F],
    ['Donor Accepted', 'Now', 0xFFD99A00],
    ['Appointment Scheduled', 'Next', 0xFFC6CEDA],
    ['Donation Completed', 'Next', 0xFFC6CEDA],
  ];

  @override
  Widget build(BuildContext context) {
    final q = kRequests.firstWhere((r) => r.id == requestId);
    return AdminScaffold(
      title: 'Request Details',
      showBack: true,
      body: LoadingGate(
        child: PageList(
          children: [
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      BloodBox(q.group, size: 52),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q.id, style: T.h),
                            Text(q.patient, style: T.sub),
                          ],
                        ),
                      ),
                      StatusBadge(q.priority),
                    ],
                  ),
                  const SizedBox(height: 6),
                  KvRow('Units required', '${q.units}'),
                  KvRow('Hospital', q.hospital),
                  KvRow('Location', q.location),
                  KvRow('Date', q.date),
                  KvRow(
                    'Status',
                    q.status,
                    last: true,
                    trailing: StatusBadge(q.status),
                  ),
                ],
              ),
            ),
            const Text('Matched Donors', style: T.h),
            for (final d in kMatchedDonors)
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Avatar(d.initials),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${d.name} · ${d.group}', style: T.title),
                              Text(
                                '${d.km} km · ${d.availability} · Last: ${d.lastDonation}',
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
                        Expanded(
                          child: AppButton(
                            'Notify Donor',
                            kind: BtnKind.outline,
                            compact: true,
                            onPressed: () => showToast(
                              context,
                              'Notification sent to donor.',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            'Assign Donor',
                            compact: true,
                            onPressed: () => showToast(
                              context,
                              'Donor assigned successfully.',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const Text('Activity', style: T.h),
            AppCard(
              child: Column(
                children: [
                  for (final t in _timeline)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Color(t[2] as int),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(t[0] as String, style: T.body)),
                          Text(t[1] as String, style: T.sub),
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
