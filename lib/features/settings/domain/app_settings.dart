class AppSettings {
  const AppSettings({
    required this.appName,
    required this.logoUrl,
    required this.primaryColor,
    required this.defaultTheme,
    required this.supportEmail,
    required this.supportUrl,
    required this.maintenanceMessage,
  });

  final String appName;
  final String logoUrl;
  final String primaryColor;
  final String defaultTheme;
  final String supportEmail;
  final String supportUrl;
  final String maintenanceMessage;

  factory AppSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppSettings(
      appName:
          json['appName']?.toString() ??
              'Easy Life',
      logoUrl:
          json['logoUrl']?.toString() ??
              '',
      primaryColor:
          json['primaryColor']
                  ?.toString() ??
              '#A78BFA',
      defaultTheme:
          json['defaultTheme']
                  ?.toString() ??
              'system',
      supportEmail:
          json['supportEmail']
                  ?.toString() ??
              '',
      supportUrl:
          json['supportUrl']?.toString() ??
              '',
      maintenanceMessage:
          json['maintenanceMessage']
                  ?.toString() ??
              '',
    );
  }
}
