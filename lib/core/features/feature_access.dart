class FeatureAccess {
  const FeatureAccess({
    required Map<String, bool> flags,
  }) : _flags = flags;

  final Map<String, bool> _flags;

  bool isEnabled(
    String key,
  ) {
    return _flags[key] == true;
  }

  bool get notifications =>
      isEnabled(
        'notifications',
      );

  bool get firebasePush =>
      isEnabled(
        'firebase_push',
      );

  bool get offlineMode =>
      isEnabled(
        'offline_mode',
      );

  bool get autoUpdateCheck =>
      isEnabled(
        'auto_update_check',
      );

  bool get maintenanceScreen =>
      isEnabled(
        'maintenance_screen',
      );

  bool get advancedDashboard =>
      isEnabled(
        'advanced_dashboard',
      );
}
