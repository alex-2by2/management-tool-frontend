class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.action,
    required this.category,
    required this.targetType,
    required this.targetId,
    required this.metadata,
    required this.success,
    required this.createdAt,
    required this.actor,
  });

  final String id;
  final String action;
  final String category;
  final String? targetType;
  final String? targetId;
  final Map<String, dynamic> metadata;
  final bool success;
  final DateTime? createdAt;
  final Map<String, dynamic>? actor;

  factory AuditEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuditEvent(
      id:
          json['id']?.toString() ??
              '',
      action:
          json['action']?.toString() ??
              '',
      category:
          json['category']?.toString() ??
              '',
      targetType:
          json['targetType']
              ?.toString(),
      targetId:
          json['targetId']
              ?.toString(),
      metadata:
          (json['metadata']
                  as Map<String, dynamic>?) ??
              const {},
      success:
          json['success'] == true,
      createdAt:
          DateTime.tryParse(
        json['createdAt']
                ?.toString() ??
            '',
      ),
      actor:
          json['actor']
              as Map<String, dynamic>?,
    );
  }
}
