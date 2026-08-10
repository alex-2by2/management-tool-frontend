import 'package:flutter/foundation.dart';

import '../data/owner_user_api.dart';

class OwnerUserController
    extends ChangeNotifier {
  OwnerUserController({
    OwnerUserApi? api,
  }) : _api =
            api ?? OwnerUserApi();

  final OwnerUserApi _api;

  List<Map<String, dynamic>>
      _users = const [];

  bool _loading = false;

  String _search = '';

  String? _role;

  String? _status;

  List<Map<String, dynamic>>
      get users => _users;

  bool get loading => _loading;

  String get search => _search;

  String? get role => _role;

  String? get status => _status;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    try {
      final result =
          await _api.list(
        search: _search,
        role: _role,
        status: _status,
      );

      final raw =
          result['users']
              as List<dynamic>? ??
          const [];

      _users = raw
          .whereType<
              Map<String, dynamic>>()
          .toList();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setRole(String? value) {
    _role = value;
    notifyListeners();
  }

  void setStatus(String? value) {
    _status = value;
    notifyListeners();
  }

  Future<void> updateStatus({
    required String userId,
    required String status,
  }) async {
    await _api.updateStatus(
      userId: userId,
      status: status,
    );

    await load();
  }

  Future<void> revokeSessions(
    String userId,
  ) async {
    await _api.revokeSessions(
      userId,
    );
  }
}
