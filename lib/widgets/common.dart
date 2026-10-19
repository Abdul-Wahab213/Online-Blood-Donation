import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum Tone { ok, warn, bad, n }

Tone toneOf(String s) {
  switch (s) {
    case 'Active':
    case 'Verified':
    case 'Completed':
    case 'Normal':
      return Tone.ok;
    case 'Pending':
    case 'Scheduled':
    case 'Low':
    case 'Urgent':
      return Tone.warn;
    case 'Suspended':
    case 'Cancelled':
    case 'Critical':
    case 'Emergency':
      return Tone.bad;
    default:
      return Tone.n;
  }
}

Color invColor(String status) => status == 'Normal'
    ? C.green
    : status == 'Low'
    ? C.amber
    : C.critical;

List<Widget> spaced(List<Widget> c, {double gap = 14}) => [
  for (var i = 0; i < c.length; i++) ...[
    if (i > 0) SizedBox(height: gap),
    c[i],
  ],
];

InputDecoration appInput({String? hint}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 14, color: C.sub),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: b(C.inputBorder),
    enabledBorder: b(C.inputBorder),
    focusedBorder: b(C.navy),
  );
}

void showToast(BuildContext context, String message) {
  final m = ScaffoldMessenger.of(context);
  m.clearSnackBars();
  m.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.navy,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 76),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(milliseconds: 2200),
      content: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFF7FD6A4), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PageList extends StatelessWidget {
  final List<Widget> children;
  const PageList({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(16), children: spaced(children));
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color ?? Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor ?? C.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Tone tone;
  StatusBadge(this.text, {super.key, Tone? tone}) : tone = tone ?? toneOf(text);

  @override
  Widget build(BuildContext context) {
    late Color bg, fg;
    switch (tone) {
      case Tone.ok:
        bg = const Color(0xFFE3F3EA);
        fg = const Color(0xFF1E6B40);
        break;
      case Tone.warn:
        bg = const Color(0xFFFFF1CC);
        fg = const Color(0xFF7A5600);
        break;
      case Tone.bad:
        bg = const Color(0xFFFBE3E3);
        fg = const Color(0xFF9B1C1C);
        break;
      case Tone.n:
        bg = const Color(0xFFE8EBF0);
        fg = C.navy;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const FilterPill(this.label, this.selected, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? C.navy : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? C.navy : C.inputBorder),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : C.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class ChipRow extends StatelessWidget {
  final List<String> items;
  final String current;
  final ValueChanged<String> onPick;
  const ChipRow({
    super.key,
    required this.items,
    required this.current,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final n in items)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilterPill(n, n == current, () => onPick(n)),
            ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String text;
  final double size;
  const Avatar(this.text, {super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: C.navy, shape: BoxShape.circle),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}

class BloodBox extends StatelessWidget {
  final String group;
  final double size;
  const BloodBox(this.group, {super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFBE3E3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        group,
        style: TextStyle(
          color: const Color(0xFF9B1C1C),
          fontWeight: FontWeight.w700,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}

class KvRow extends StatelessWidget {
  final String k;
  final String v;
  final bool last;
  final Widget? trailing;
  const KvRow(this.k, this.v, {super.key, this.last = false, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: C.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: T.body.copyWith(color: C.sub)),
          const SizedBox(width: 12),
          Flexible(
            child:
                trailing ?? Text(v, textAlign: TextAlign.right, style: T.body),
          ),
        ],
      ),
    );
  }
}

enum BtnKind { primary, outline, danger, success, plain }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BtnKind kind;
  final bool compact;
  const AppButton(
    this.label, {
    super.key,
    this.onPressed,
    this.kind = BtnKind.primary,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final h = compact ? 40.0 : 44.0;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final text = TextStyle(
      fontSize: compact ? 13 : 14,
      fontWeight: FontWeight.w600,
    );
    final pad = EdgeInsets.symmetric(horizontal: compact ? 6 : 16);
    final child = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    final Widget btn;
    if (kind == BtnKind.outline) {
      btn = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: C.navy,
          backgroundColor: Colors.white,
          side: const BorderSide(color: C.navy, width: 1.5),
          shape: shape,
          textStyle: text,
          padding: pad,
          minimumSize: Size(0, h),
        ),
        child: child,
      );
    } else if (kind == BtnKind.plain) {
      btn = TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: C.navy,
          shape: shape,
          textStyle: text,
          padding: pad,
          minimumSize: Size(0, h),
        ),
        child: child,
      );
    } else {
      final bg = kind == BtnKind.danger
          ? C.red
          : kind == BtnKind.success
          ? C.green
          : C.navy;
      btn = FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          shape: shape,
          textStyle: text,
          padding: pad,
          minimumSize: Size(0, h),
        ),
        child: child,
      );
    }
    return SizedBox(width: double.infinity, height: h, child: btn);
  }
}

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const SearchField({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: appInput(hint: hint),
  );
}

class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const ProgressBar({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: C.track,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  final String title;
  final String message;
  const EmptyCard(this.title, this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Text(title, style: T.title),
          const SizedBox(height: 2),
          Text(message, textAlign: TextAlign.center, style: T.sub),
        ],
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  final VoidCallback onRetry;
  const ErrorStateView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return PageList(
      children: [
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE3E3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFF9B1C1C),
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Unable to load data', style: T.h),
              const SizedBox(height: 4),
              const Text('Something went wrong.', style: T.sub),
              const SizedBox(height: 16),
              AppButton('Try Again', onPressed: onRetry),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------- Loading skeletons ----------

class Skel extends StatelessWidget {
  final double? w;
  final double h;
  final double r;
  const Skel({super.key, this.w, required this.h, this.r = 8});

  @override
  Widget build(BuildContext context) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: C.skeleton,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

/// Shows a skeleton for [ms] milliseconds, then the real [child].
class LoadingGate extends StatefulWidget {
  final Widget child;
  final bool dashboard;
  final int ms;
  const LoadingGate({
    super.key,
    required this.child,
    this.dashboard = false,
    this.ms = 700,
  });

  @override
  State<LoadingGate> createState() => _LoadingGateState();
}

class _LoadingGateState extends State<LoadingGate> {
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: widget.ms), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading) return widget.child;
    return widget.dashboard ? const _DashSkeleton() : const _ListSkeleton();
  }
}

class _SkelRow extends StatelessWidget {
  const _SkelRow();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Row(
        children: [
          Skel(w: 40, h: 40, r: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(widthFactor: .7, child: Skel(h: 12, r: 6)),
                SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: .45,
                  child: Skel(h: 10, r: 6),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Skel(w: 56, h: 24, r: 8),
        ],
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return PageList(
      children: [
        const Skel(h: 44, r: 12),
        const Row(
          children: [
            Skel(w: 70, h: 36, r: 18),
            SizedBox(width: 10),
            Skel(w: 90, h: 36, r: 18),
            SizedBox(width: 10),
            Skel(w: 80, h: 36, r: 18),
          ],
        ),
        for (var i = 0; i < 6; i++) const _SkelRow(),
      ],
    );
  }
}

class _DashSkeleton extends StatelessWidget {
  const _DashSkeleton();

  @override
  Widget build(BuildContext context) {
    return PageList(
      children: [
        const FractionallySizedBox(widthFactor: .6, child: Skel(h: 28)),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            for (var i = 0; i < 6; i++)
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(widthFactor: .4, child: Skel(h: 14)),
                    SizedBox(height: 12),
                    FractionallySizedBox(widthFactor: .7, child: Skel(h: 22)),
                    SizedBox(height: 10),
                    FractionallySizedBox(widthFactor: .55, child: Skel(h: 10)),
                  ],
                ),
              ),
          ],
        ),
        const Skel(h: 150, r: 14),
      ],
    );
  }
}
