class ApiKeyItem {
  const ApiKeyItem({
    required this.id,
    required this.name,
    required this.prefix,
    required this.scopes,
    required this.status,
    required this.lastUsedAt,
    required this.expiresAt,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String prefix;
  final List<String> scopes;
  final String status;
  final DateTime? lastUsedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  factory ApiKeyItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApiKeyItem(
      id:
          json['id']?.toString() ??
              '',
      name:
          json['name']?.toString() ??
              '',
      prefix:
          json['prefix']?.toString() ??
              '',
      scopes:
          (json['scopes']
                  as List<dynamic>? ??
              const [])
              .map(
                (item) =>
                    item.toString(),
              )
              .toList(),
      status:
          json['status']?.toString() ??
              'active',
      lastUsedAt:
          DateTime.tryParse(
        json['lastUsedAt']
                ?.toString() ??
            '',
      ),
      expiresAt:
          DateTime.tryParse(
        json['expiresAt']
                ?.toString() ??
            '',
      ),
      createdAt:
          DateTime.tryParse(
        json['createdAt']
                ?.toString() ??
            '',
      ),
    );
  }
}
