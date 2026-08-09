class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? details;

  bool get isUnauthorized =>
      statusCode == 401;

  bool get isForbidden =>
      statusCode == 403;

  bool get isNotFound =>
      statusCode == 404;

  bool get isRateLimited =>
      statusCode == 429;

  bool get isMaintenance =>
      code == 'MAINTENANCE_MODE';

  bool get isServerError =>
      statusCode != null &&
      statusCode! >= 500;
}
