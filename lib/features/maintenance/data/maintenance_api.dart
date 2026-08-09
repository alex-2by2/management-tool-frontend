import '../../../core/network/api_client.dart';
import '../domain/maintenance_status.dart';

class MaintenanceApi {
  MaintenanceApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<MaintenanceStatus>
      status() async {
    final response =
        await _apiClient.get(
      '/maintenance',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return MaintenanceStatus
        .fromJson(data);
  }

  Future<MaintenanceStatus>
      update({
    required bool enabled,
    required String title,
    required String message,
    DateTime? estimatedEndAt,
  }) async {
    final response =
        await _apiClient.patch(
      '/owner/maintenance',
      data: {
        'enabled': enabled,
        'title': title,
        'message': message,
        'estimatedEndAt':
            estimatedEndAt
                ?.toUtc()
                .toIso8601String(),
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return MaintenanceStatus
        .fromJson(data);
  }
}
