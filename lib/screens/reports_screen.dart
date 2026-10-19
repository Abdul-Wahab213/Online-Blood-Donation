import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _range = '30 Days';
  DateTime _from = DateTime(2026, 9, 1);
  DateTime _to = DateTime(2026, 10, 5);

  Future<void> _pick(bool isFrom) async {
    final d = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => isFrom ? _from = d : _to = d);
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Reports & Statistics',
      body: LoadingGate(
        child: PageList(
          children: [
            ChipRow(
              items: const [
                '7 Days',
                '30 Days',
                '3 Months',
                '6 Months',
                '1 Year',
                'Custom',
              ],
              current: _range,
              onPick: (v) => setState(() => _range = v),
            ),
            if (_range == 'Custom')
              Row(
                children: [
                  Expanded(child: _DateBox(_from, () => _pick(true))),
                  const SizedBox(width: 10),
                  Expanded(child: _DateBox(_to, () => _pick(false))),
                ],
              ),
            const DistributionCard(),
            const RequestsTrendCard(),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Successful Donation Rate', style: T.h),
                  const SizedBox(height: 4),
                  const Text('74.7%', style: T.value),
                  const SizedBox(height: 4),
                  const ProgressBar(value: 0.747, color: C.green),
                ],
              ),
            ),
            const TrendBarsCard(
              title: 'Monthly Donations',
              subtitle: 'Total 4,015 · Avg 502/mo · ▲ 15.6%',
              color: C.blue1,
              height: 100,
            ),
            const TrendBarsCard(
              title: 'Donor Registration Trends',
              subtitle: 'New donors per month · ▲ 12.4%',
              color: C.blue1,
              height: 100,
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Emergency Requests', style: T.h),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Num('58', 'Emergency', color: C.red),
                      _Num('46', 'Fulfilled'),
                      _Num('79%', 'Fulfil rate'),
                    ],
                  ),
                ],
              ),
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Users', style: T.h),
                  const SizedBox(height: 4),
                  const Text('1,936', style: T.value),
                  const SizedBox(height: 4),
                  const ProgressBar(value: 0.62, color: C.navy),
                  const SizedBox(height: 4),
                  const Text(
                    'Donors 1,320 · Patients 410 · Orgs 206',
                    style: T.sub,
                  ),
                ],
              ),
            ),
            const InventoryTrendCard(),
            AppButton(
              'Generate Report',
              onPressed: () async {
                final ok = await showReportSheet(context, _range);
                if (ok == true && context.mounted)
                  showToast(context, 'Report generated successfully.');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Num extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Num(this.value, this.label, {this.color = C.ink});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(label, style: T.sub),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DateBox(this.date, this.onTap);

  @override
  Widget build(BuildContext context) {
    final text =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: C.inputBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: C.ink),
              ),
            ),
            const Icon(Icons.calendar_today, size: 16, color: C.sub),
          ],
        ),
      ),
    );
  }
}
