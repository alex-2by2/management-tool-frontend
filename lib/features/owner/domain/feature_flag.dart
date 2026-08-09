class FeatureFlag {
  const FeatureFlag({
    required this.key,
    required this.name,
    required this.description,
    required this.enabled,
    required this.environment,
    required this.updatedAt,
  });

  final String key;
  final String name;
  final String description;
  final bool enabled;
  final String environment;
  final DateTime? updatedAt;

  factory FeatureFlag.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeatureFlag(
      key:
          json['key']?.toString() ??
              '',
      name:
          json['name']?.toString() ??
              '',
      description:
          json['description']
                  ?.toString() ??
              '',
      enabled:
          json['enabled'] == true,
      environment:
          json['environment']
                  ?.toString() ??
              'all',
      updatedAt:
          DateTime.tryParse(
        json['updatedAt']
                ?.toString() ??
            '',
      ),
    );
  }
}
