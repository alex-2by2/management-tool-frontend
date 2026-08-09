import 'package:flutter/foundation.dart';

import '../data/feature_flag_api.dart';
import '../domain/feature_flag.dart';

class FeatureFlagController
    extends ChangeNotifier {
  FeatureFlagController({
    FeatureFlagApi? api,
  }) : _api =
            api ?? FeatureFlagApi();

  final FeatureFlagApi _api;

  List<FeatureFlag> _features =
      const [];

  bool _loading = false;

  String? _error;

  List<FeatureFlag> get features =>
      _features;

  bool get loading =>
      _loading;

  String? get error =>
      _error;

  Future<void> load() async {
    _loading = true;
    _error = null;

    notifyListeners();

    try {
      _features =
          await _api.list();
    } catch (error) {
      _error =
          error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggle(
    FeatureFlag feature,
    bool enabled,
  ) async {
    final updated =
        await _api.update(
      key: feature.key,
      enabled: enabled,
    );

    _features =
        _features.map(
      (item) {
        return item.key ==
                updated.key
            ? updated
            : item;
      },
    ).toList();

    notifyListeners();
  }
}
