import 'package:flutter/foundation.dart';

import '../data/session_api.dart';
import '../domain/user_session.dart';

class SessionController
    extends ChangeNotifier {
  SessionController({
    SessionApi? api,
    this.currentSessionId,
  }) : _api =
            api ?? SessionApi();

  final SessionApi _api;

  final String? currentSessionId;

  List<UserSession> _sessions =
      const [];

  bool _loading = false;

  String? _error;

  List<UserSession> get sessions =>
      _sessions;

  bool get loading =>
      _loading;

  String? get error =>
      _error;

  Future<void> load() async {
    _loading = true;
    _error = null;

    notifyListeners();

    try {
      _sessions =
          await _api.list(
        currentSessionId:
            currentSessionId,
      );
    } catch (error) {
      _error =
          error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> revoke(
    UserSession session,
  ) async {
    await _api.revoke(
      session.id,
    );

    _sessions =
        _sessions
            .where(
              (item) =>
                  item.id !=
                  session.id,
            )
            .toList();

    notifyListeners();
  }

  Future<void>
      revokeOthers() async {
    await _api.revokeOthers();

    _sessions =
        _sessions
            .where(
              (item) =>
                  item.current,
            )
            .toList();

    notifyListeners();
  }
}
