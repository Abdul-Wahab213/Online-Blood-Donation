import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  Future<void> _addStock(BuildContext context) async {
    final ok = await showStockSheet(context);
    if (ok == true && context.mounted)
      showToast(context, 'Blood inventory updated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Blood Inventory',
      showBack: true,
      body: LoadingGate(
        child: PageList(
          children: [
            AppButton('+ Add Stock', onPressed: () => _addStock(context)),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.25,
              children: [
                for (final g in kInventory)
                  AppCard(
                    onTap: () => _addStock(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              g.group,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: C.ink,
                              ),
                            ),
                            StatusBadge(g.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${g.available} ', style: T.h),
                              const TextSpan(text: 'units', style: T.sub),
                            ],
                          ),
                        ),
                        Text('Reserved: ${g.reserved}', style: T.sub),
                        const SizedBox(height: 6),
                        ProgressBar(
                          value: g.fraction,
                          color: invColor(g.status),
                        ),
                      ],
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
