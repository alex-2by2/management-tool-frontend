class MaintenanceStatus {
  const MaintenanceStatus({
    required this.enabled,
    required this.title,
    required this.message,
    required this.estimatedEndAt,
  });

  final bool enabled;
  final String title;
  final String message;
  final DateTime? estimatedEndAt;

  factory MaintenanceStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaintenanceStatus(
      enabled:
          json['enabled'] == true,
      title:
          json['title']?.toString() ??
              'Maintenance',
      message:
          json['message']?.toString() ??
              '',
      estimatedEndAt:
          DateTime.tryParse(
        json['estimatedEndAt']
                ?.toString() ??
            '',
      ),
    );
  }
}
