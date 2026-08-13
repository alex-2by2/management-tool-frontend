import 'package:flutter/foundation.dart';

import '../data/owner_dashboard_api.dart';

class OwnerDashboardController
    extends ChangeNotifier {
  OwnerDashboardController({
    OwnerDashboardApi? api,
  }) : _api =
            api ?? OwnerDashboardApi();

  final OwnerDashboardApi _api;

  Map<String, dynamic>
      _overview = const {};

  bool _loading = false;

  String? _error;

  Map<String, dynamic>
      get overview =>
          _overview;

  bool get loading =>
      _loading;

  String? get error =>
      _error;

  Future<void> load() async {
    _loading = true;
    _error = null;

    notifyListeners();

    try {
      _overview =
          await _api.getOverview();
    } catch (error) {
      _error =
          error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  int get totalUsers =>
      _number(
        _overview['users']
            ?['total'],
      );

  int get adminUsers =>
      _number(
        _overview['users']
            ?['admins'],
      );

  int get supportUsers =>
      _number(
        _overview['users']
            ?['support'],
      );

  int get normalUsers =>
      _number(
        _overview['users']
            ?['users'],
      );

  String get apiStatus =>
      _string(
        _overview['system']
            ?['api']?['status'],
      );

  String get databaseStatus =>
      _string(
        _overview['system']
            ?['database']?['status'],
      );

  int get uptimeSeconds =>
      _number(
        _overview['system']
            ?['api']
                ?['uptimeSeconds'],
      );

  String get version =>
      _string(
        _overview['version'],
      );

  String get environment =>
      _string(
        _overview['environment'],
      );

  int _number(
    dynamic value,
  ) {
    return value is num
        ? value.toInt()
        : 0;
  }

  String _string(
    dynamic value,
  ) {
    return value?.toString() ??
        '';
  }
}
