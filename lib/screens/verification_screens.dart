import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';

class VerificationScreen extends StatefulWidget {
  final bool isDonor;
  final String orgType; // 'Hospitals' or 'Blood Banks'
  const VerificationScreen({
    super.key,
    this.isDonor = true,
    this.orgType = 'Hospitals',
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late String _type = widget.orgType;

  List<VerificationItem> _items() {
    final all = widget.isDonor
        ? kDonorVerifications
        : kOrgVerifications.where((o) => '${o.kind}s' == _type).toList();
    return all.where((v) => !AppState.i.handled.contains(v.key)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: widget.isDonor ? 'Donor Verification' : 'Hospital & Blood Bank',
      showBack: true,
      body: LoadingGate(
        child: ListenableBuilder(
          listenable: AppState.i,
          builder: (context, _) {
            final list = _items();
            return PageList(
              children: [
                if (!widget.isDonor)
                  Row(
                    children: [
                      Expanded(
                        child: FilterPill(
                          'Hospitals',
                          _type == 'Hospitals',
                          () => setState(() => _type = 'Hospitals'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterPill(
                          'Blood Banks',
                          _type == 'Blood Banks',
                          () => setState(() => _type = 'Blood Banks'),
                        ),
                      ),
                    ],
                  ),
                if (widget.isDonor)
                  AppCard(
                    color: const Color(0xFFFFF1CC),
                    borderColor: const Color(0xFFF0D58A),
                    child: Text('${list.length} Pending', style: T.title),
                  ),
                for (final v in list)
                  AppCard(
                    child: Row(
                      children: [
                        Avatar(v.initials),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.name, style: T.title),
                              Text(v.subtitle, style: T.sub),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 84,
                          child: AppButton(
                            'Review',
                            compact: true,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    VerificationDetailsScreen(item: v),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (list.isEmpty)
                  const EmptyCard(
                    'No pending verifications',
                    'All verification requests have been reviewed.',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VerificationDetailsScreen extends StatelessWidget {
  final VerificationItem item;
  const VerificationDetailsScreen({super.key, required this.item});

  Future<void> _reject(BuildContext context) async {
    final ok = await showRejectSheet(context);
    if (ok == true && context.mounted) {
      AppState.i.markHandled(item.key);
      showToast(context, '${item.kind} verification rejected.');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Verification Details',
      showBack: true,
      body: LoadingGate(
        child: PageList(
          children: [
            AppCard(
              child: Column(
                children: [
                  Avatar(item.initials, size: 64),
                  const SizedBox(height: 8),
                  Text(item.name, textAlign: TextAlign.center, style: T.h),
                  Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: T.sub,
                  ),
                ],
              ),
            ),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < item.rows.length; i++)
                    KvRow(
                      item.rows[i].key,
                      item.rows[i].value,
                      last: i == item.rows.length - 1,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    'Reject',
                    kind: BtnKind.danger,
                    onPressed: () => _reject(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    'Approve',
                    kind: BtnKind.success,
                    onPressed: () {
                      AppState.i.markHandled(item.key);
                      showToast(context, '${item.kind} verified successfully.');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
