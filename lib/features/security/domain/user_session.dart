enum SessionPlatform {
  android,
  ios,
  web,
  unknown,
}

class UserSession {
  const UserSession({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.ipAddress,
    required this.lastActiveAt,
    required this.expiresAt,
    required this.createdAt,
    required this.current,
  });

  final String id;
  final String deviceId;
  final String deviceName;
  final SessionPlatform platform;
  final String? ipAddress;
  final DateTime? lastActiveAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final bool current;

  factory UserSession.fromJson(
    Map<String, dynamic> json, {
    String? currentSessionId,
  }) {
    return UserSession(
      id:
          json['id']?.toString() ??
              '',
      deviceId:
          json['deviceId']
                  ?.toString() ??
              '',
      deviceName:
          json['deviceName']
                  ?.toString() ??
              'Unknown device',
      platform:
          SessionPlatform.values
              .firstWhere(
        (item) =>
            item.name ==
            json['platform'],
        orElse:
            () =>
                SessionPlatform
                    .unknown,
      ),
      ipAddress:
          json['ipAddress']
              ?.toString(),
      lastActiveAt:
          DateTime.tryParse(
        json['lastActiveAt']
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
      current:
          currentSessionId !=
                  null &&
              currentSessionId ==
                  json['id'],
    );
  }
}
