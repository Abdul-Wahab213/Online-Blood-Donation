import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';

/// Small app-wide state (no extra packages needed).
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState i = AppState._();

  int tab = 0; // 0 Dashboard, 1 Users, 2 Requests, 3 Reports, 4 More
  String userFilter = 'All';
  final Set<String> suspended = {};
  final Set<String> handled = {};
  final Set<int> read = {};

  void openTab(int t, {String filter = 'All'}) {
    tab = t;
    userFilter = filter;
    notifyListeners();
  }

  void reset() {
    tab = 0;
    userFilter = 'All';
    notifyListeners();
  }

  bool isSuspended(String id) => suspended.contains(id);

  void setSuspended(String id, bool value) {
    if (value) {
      suspended.add(id);
    } else {
      suspended.remove(id);
    }
    notifyListeners();
  }

  void markHandled(String key) {
    handled.add(key);
    notifyListeners();
  }

  int get unreadCount => kNotifications.length - read.length;

  void markRead(int index) {
    read.add(index);
    notifyListeners();
  }

  void markAllRead() {
    read.addAll(List.generate(kNotifications.length, (i) => i));
    notifyListeners();
  }
}
