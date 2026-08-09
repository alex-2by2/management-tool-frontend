import '../../../core/network/api_client.dart';
import '../domain/system_health.dart';

class HealthApi {
  HealthApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<SystemHealth>
      getHealth() async {
    final response =
        await _apiClient.get(
      '/owner/health',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return SystemHealth.fromJson(
      data,
    );
  }
}
