import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'common.dart';

Future<bool?> _openSheet(
  BuildContext context,
  List<Widget> Function(BuildContext) build,
) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    barrierColor: C.scrim,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: spaced(build(ctx), gap: 12),
          ),
        ),
      ),
    ),
  );
}

Widget _actions(
  BuildContext ctx,
  String confirm,
  BtnKind kind, {
  int flex = 1,
}) {
  return Row(
    children: [
      Expanded(
        child: AppButton(
          'Cancel',
          kind: BtnKind.outline,
          onPressed: () => Navigator.pop(ctx, false),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        flex: flex,
        child: AppButton(
          confirm,
          kind: kind,
          onPressed: () => Navigator.pop(ctx, true),
        ),
      ),
    ],
  );
}

class _Dropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  const _Dropdown(this.label, this.items);

  @override
  State<_Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<_Dropdown> {
  late String _v = widget.items.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: T.sub.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _v,
          isExpanded: true,
          decoration: appInput(),
          items: [
            for (final i in widget.items)
              DropdownMenuItem(
                value: i,
                child: Text(
                  i,
                  style: const TextStyle(fontSize: 14, color: C.ink),
                ),
              ),
          ],
          onChanged: (v) => setState(() => _v = v ?? _v),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String initial;
  const _Field(this.label, this.initial);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: T.sub.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextFormField(initialValue: initial, decoration: appInput()),
      ],
    );
  }
}

Widget _notes(String hint) =>
    TextField(minLines: 2, maxLines: 3, decoration: appInput(hint: hint));

Future<bool?> showSuspendSheet(BuildContext context) => _openSheet(
  context,
  (ctx) => [
    const Text('Suspend Account?', style: T.h),
    const Text('Are you sure you want to suspend this account?', style: T.sub),
    const _Dropdown('Reason', [
      'Fake information',
      'Suspicious activity',
      'Duplicate account',
      'Invalid verification',
      'Other',
    ]),
    _notes('Additional notes'),
    _actions(ctx, 'Suspend', BtnKind.danger),
  ],
);

Future<bool?> showActivateSheet(BuildContext context) => _openSheet(
  context,
  (ctx) => [
    const Text('Activate Account', style: T.h),
    const Text(
      'Are you sure you want to reactivate this account?',
      style: T.sub,
    ),
    _actions(ctx, 'Activate', BtnKind.success),
  ],
);

Future<bool?> showRejectSheet(BuildContext context) => _openSheet(
  context,
  (ctx) => [
    const Text('Reject Verification', style: T.h),
    const Text('Please provide a reason.', style: T.sub),
    const _Dropdown('Reason', [
      'Fake information',
      'Invalid information',
      'Duplicate account',
      'Eligibility issue',
      'Other',
    ]),
    _notes('Additional notes'),
    _actions(ctx, 'Reject', BtnKind.danger),
  ],
);

Future<bool?> showStockSheet(BuildContext context) => _openSheet(
  context,
  (ctx) => [
    const Text('Add Blood Stock', style: T.h),
    const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Dropdown('Blood Group', [
            'O-',
            'O+',
            'A+',
            'A-',
            'B+',
            'B-',
            'AB+',
            'AB-',
          ]),
        ),
        SizedBox(width: 10),
        Expanded(child: _Field('Units', '10')),
      ],
    ),
    const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _Field('Expiry Date', '30 Nov 2026')),
        SizedBox(width: 10),
        Expanded(child: _Field('Source', 'Red Crescent')),
      ],
    ),
    _notes('Notes'),
    _actions(ctx, 'Add Inventory', BtnKind.primary, flex: 2),
  ],
);

Future<bool?> showReportSheet(BuildContext context, String range) => _openSheet(
  context,
  (ctx) => [
    const Text('Generate Report', style: T.h),
    Text('Range: $range', style: T.sub),
    AppButton('Generate Report', onPressed: () => Navigator.pop(ctx, true)),
    Row(
      children: [
        Expanded(
          child: AppButton(
            'Export PDF',
            kind: BtnKind.outline,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton(
            'Export CSV',
            kind: BtnKind.outline,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ),
      ],
    ),
    AppButton(
      'Cancel',
      kind: BtnKind.plain,
      onPressed: () => Navigator.pop(ctx, false),
    ),
  ],
);

/// Suspend / activate flow used by the Users list and User Details.
Future<void> runSuspendFlow(BuildContext context, String userId) async {
  final wasSuspended = AppState.i.isSuspended(userId);
  final ok = wasSuspended
      ? await showActivateSheet(context)
      : await showSuspendSheet(context);
  if (ok == true) {
    AppState.i.setSuspended(userId, !wasSuspended);
    if (context.mounted) {
      showToast(
        context,
        wasSuspended
            ? 'User account activated successfully.'
            : 'User account suspended successfully.',
      );
    }
  }
}
