class RuntimeInfo {
  const RuntimeInfo({
    required this.version,
    required this.environment,
    required this.commitSha,
    required this.buildTime,
    required this.nodeVersion,
    required this.uptimeSeconds,
  });

  final String version;
  final String environment;
  final String? commitSha;
  final String? buildTime;
  final String nodeVersion;
  final int uptimeSeconds;

  factory RuntimeInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    return RuntimeInfo(
      version:
          json['version']
                  ?.toString() ??
              '0.0.0',
      environment:
          json['environment']
                  ?.toString() ??
              'unknown',
      commitSha:
          json['commitSha']
              ?.toString(),
      buildTime:
          json['buildTime']
              ?.toString(),
      nodeVersion:
          json['nodeVersion']
                  ?.toString() ??
              '',
      uptimeSeconds:
          (json['uptimeSeconds']
                      as num?)
                  ?.toInt() ??
              0,
    );
  }
}
