import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'common.dart';

const _donutParts = <double>[32, 28, 18, 8, 5, 4, 3, 2];
const _donutColors = <Color>[
  Color(0xFF1D2B3D),
  Color(0xFF3F5F8A),
  Color(0xFF6E8FB8),
  Color(0xFFB3192B),
  Color(0xFFE0707B),
  Color(0xFF9CA8B8),
  Color(0xFFC6CEDA),
  Color(0xFF5B6472),
];
const _donutLabels = [
  'O+ 32%',
  'A+ 28%',
  'B+ 18%',
  'AB+ 8%',
  'O- 5%',
  'A- 4%',
  'B- 3%',
  'AB- 2%',
];

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 24.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    var start = -math.pi / 2;
    for (var i = 0; i < _donutParts.length; i++) {
      final sweep = _donutParts[i] / 100 * 2 * math.pi;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = _donutColors[i],
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DistributionCard extends StatelessWidget {
  const DistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Blood Group Distribution', style: T.h),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(110, 110),
                      painter: _DonutPainter(),
                    ),
                    const Text(
                      '2,458',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: C.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 4,
                  children: [
                    for (final l in _donutLabels)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(l, style: T.sub.copyWith(color: C.ink)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> heights;
  final List<String>? valueLabels;
  final double height;
  final Color color;
  const BarChart({
    super.key,
    required this.labels,
    required this.heights,
    this.valueLabels,
    this.height = 110,
    this.color = C.navy,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (valueLabels != null)
                      Text(
                        valueLabels![i],
                        style: const TextStyle(fontSize: 10, color: C.ink),
                      ),
                    const SizedBox(height: 4),
                    Container(
                      height: heights[i],
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: const TextStyle(fontSize: 10, color: C.sub),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

const _monthLabels = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
const _monthValues = [300, 340, 420, 470, 520, 632];

class TrendBarsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final bool showValues;
  final double height;
  const TrendBarsCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.color = C.navy,
    this.showValues = false,
    this.height = 124,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: T.h),
          const SizedBox(height: 2),
          Text(subtitle, style: T.sub),
          const SizedBox(height: 10),
          BarChart(
            labels: _monthLabels,
            heights: [for (final v in _monthValues) v / 632 * 80],
            valueLabels: showValues
                ? [for (final v in _monthValues) '$v']
                : null,
            color: color,
            height: height,
          ),
        ],
      ),
    );
  }
}

const _rLabels = {
  'Weekly': ['W1', 'W2', 'W3', 'W4', 'W5'],
  'Monthly': ['Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
  'Yearly': ['22', '23', '24', '25', '26'],
};
const _rValues = {
  'Weekly': [20.0, 28.0, 24.0, 30.0, 18.0],
  'Monthly': [60.0, 74.0, 88.0, 96.0, 70.0],
  'Yearly': [50.0, 64.0, 80.0, 92.0, 100.0],
};

class RequestsTrendCard extends StatefulWidget {
  const RequestsTrendCard({super.key});

  @override
  State<RequestsTrendCard> createState() => _RequestsTrendCardState();
}

class _RequestsTrendCardState extends State<RequestsTrendCard> {
  String _mode = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Blood Requests', style: T.h),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final m in _rLabels.keys)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterPill(
                      m,
                      m == _mode,
                      () => setState(() => _mode = m),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          BarChart(
            labels: _rLabels[_mode]!,
            heights: [for (final v in _rValues[_mode]!) v * 0.9],
          ),
          const SizedBox(height: 6),
          const Text(
            'Pending · Accepted · Completed · Cancelled totals: 124 · 210 · 632 · 48',
            style: T.sub,
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const pts = [
      Offset(10, 70),
      Offset(70, 60),
      Offset(130, 64),
      Offset(190, 40),
      Offset(250, 34),
      Offset(310, 20),
    ];
    final sx = size.width / 320;
    final sy = size.height / 90;
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final p = Offset(pts[i].dx * sx, pts[i].dy * sy);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = C.navy,
    );
    canvas.drawCircle(Offset(310 * sx, 20 * sy), 4, Paint()..color = C.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InventoryTrendCard extends StatelessWidget {
  const InventoryTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Inventory Trends', style: T.h),
          const SizedBox(height: 6),
          SizedBox(
            height: 90,
            width: double.infinity,
            child: CustomPaint(painter: _LinePainter()),
          ),
          const SizedBox(height: 4),
          const Text('Total units: 3,900 → 4,820 over 6 months', style: T.sub),
        ],
      ),
    );
  }
}

/// Used on the dashboard: one row per blood group.
class InventoryBars extends StatelessWidget {
  const InventoryBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final g in kInventory)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    g.group,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: C.ink,
                    ),
                  ),
                ),
                Expanded(
                  child: ProgressBar(
                    value: g.fraction,
                    color: invColor(g.status),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 92,
                  child: Text(
                    '${g.available} · ${g.status}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, color: C.ink),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
