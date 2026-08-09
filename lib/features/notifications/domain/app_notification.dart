class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.channel,
    required this.publishedAt,
    required this.readAt,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final String channel;
  final DateTime? publishedAt;
  final DateTime? readAt;

  bool get isRead =>
      readAt != null;

  factory AppNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppNotification(
      id:
          json['id']?.toString() ??
              '',
      title:
          json['title']?.toString() ??
              '',
      message:
          json['message']?.toString() ??
              '',
      type:
          json['type']?.toString() ??
              'system',
      channel:
          json['channel']?.toString() ??
              'in_app',
      publishedAt:
          DateTime.tryParse(
        json['publishedAt']
                ?.toString() ??
            '',
      ),
      readAt:
          DateTime.tryParse(
        json['readAt']
                ?.toString() ??
            '',
      ),
    );
  }
}
