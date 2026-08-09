class SystemHealth {
  const SystemHealth({
    required this.status,
    required this.checkedAt,
    required this.backend,
    required this.database,
    required this.runtime,
    required this.memory,
  });

  final String status;
  final DateTime? checkedAt;
  final HealthComponent backend;
  final HealthComponent database;
  final RuntimeHealth runtime;
  final MemoryHealth memory;

  factory SystemHealth.fromJson(
    Map<String, dynamic> json,
  ) {
    return SystemHealth(
      status:
          json['status']?.toString() ??
              'unknown',
      checkedAt:
          DateTime.tryParse(
        json['checkedAt']
                ?.toString() ??
            '',
      ),
      backend:
          HealthComponent.fromJson(
        (json['backend']
                as Map<String, dynamic>?) ??
            const {},
      ),
      database:
          HealthComponent.fromJson(
        (json['database']
                as Map<String, dynamic>?) ??
            const {},
      ),
      runtime:
          RuntimeHealth.fromJson(
        (json['runtime']
                as Map<String, dynamic>?) ??
            const {},
      ),
      memory:
          MemoryHealth.fromJson(
        (json['memory']
                as Map<String, dynamic>?) ??
            const {},
      ),
    );
  }
}

class HealthComponent {
  const HealthComponent({
    required this.status,
    required this.latencyMs,
  });

  final String status;
  final double? latencyMs;

  factory HealthComponent.fromJson(
    Map<String, dynamic> json,
  ) {
    return HealthComponent(
      status:
          json['status']?.toString() ??
              'unknown',
      latencyMs:
          (json['latencyMs']
                  as num?)
              ?.toDouble(),
    );
  }
}

class RuntimeHealth {
  const RuntimeHealth({
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

  factory RuntimeHealth.fromJson(
    Map<String, dynamic> json,
  ) {
    return RuntimeHealth(
      version:
          json['version']?.toString() ??
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

class MemoryHealth {
  const MemoryHealth({
    required this.rss,
    required this.heapUsed,
    required this.heapTotal,
    required this.external,
  });

  final int rss;
  final int heapUsed;
  final int heapTotal;
  final int external;

  factory MemoryHealth.fromJson(
    Map<String, dynamic> json,
  ) {
    return MemoryHealth(
      rss:
          (json['rss'] as num?)
                  ?.toInt() ??
              0,
      heapUsed:
          (json['heapUsed']
                      as num?)
                  ?.toInt() ??
              0,
      heapTotal:
          (json['heapTotal']
                      as num?)
                  ?.toInt() ??
              0,
      external:
          (json['external']
                      as num?)
                  ?.toInt() ??
              0,
    );
  }
}
