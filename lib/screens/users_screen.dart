import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';
import 'user_details_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late String _filter = AppState.i.userFilter;
  String _q = '';
  String? _menuId;

  static const _filters = [
    'All',
    'Donors',
    'Patients',
    'Hospitals',
    'Blood Banks',
    'Active',
    'Suspended',
  ];

  bool _match(UserItem u) {
    final status = AppState.i.isSuspended(u.id) ? 'Suspended' : 'Active';
    final byFilter =
        _filter == 'All' || '${u.role}s' == _filter || status == _filter;
    final hay = (u.name + u.email + u.role).toLowerCase();
    return byFilter && (_q.isEmpty || hay.contains(_q.toLowerCase()));
  }

  void _open(UserItem u) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => UserDetailsScreen(userId: u.id)));

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Manage Users',
      body: LoadingGate(
        child: ListenableBuilder(
          listenable: AppState.i,
          builder: (context, _) {
            final list = kUsers.where(_match).toList();
            return PageList(
              children: [
                SearchField(
                  hint: 'Search users...',
                  onChanged: (v) => setState(() => _q = v),
                ),
                ChipRow(
                  items: _filters,
                  current: _filter,
                  onPick: (v) => setState(() => _filter = v),
                ),
                for (final u in list) _userCard(u),
                if (list.isEmpty)
                  const EmptyCard('No users found', 'Try a different filter.'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _userCard(UserItem u) {
    final suspended = AppState.i.isSuspended(u.id);
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _open(u),
                  child: Row(
                    children: [
                      Avatar(u.initials),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: T.title),
                            Text(
                              '${u.role} · ${u.email}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: T.sub,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      StatusBadge(suspended ? 'Suspended' : 'Active'),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'More actions',
                icon: const Icon(Icons.more_vert),
                onPressed: () =>
                    setState(() => _menuId = _menuId == u.id ? null : u.id),
              ),
            ],
          ),
          if (_menuId == u.id)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      'View',
                      kind: BtnKind.outline,
                      compact: true,
                      onPressed: () => _open(u),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      'Edit',
                      kind: BtnKind.outline,
                      compact: true,
                      onPressed: () =>
                          showToast(context, 'Edit form opens here.'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      suspended ? 'Activate' : 'Suspend',
                      kind: BtnKind.danger,
                      compact: true,
                      onPressed: () => runSuspendFlow(context, u.id),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
