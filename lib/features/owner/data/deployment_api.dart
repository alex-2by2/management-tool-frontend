import '../../../core/network/api_client.dart';
import '../domain/runtime_info.dart';

class DeploymentApi {
  DeploymentApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<RuntimeInfo>
      runtime() async {
    final response =
        await _apiClient.get(
      '/owner/deployment/runtime',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return RuntimeInfo.fromJson(
      data,
    );
  }

  Future<List<Map<String, dynamic>>>
      history() async {
    final response =
        await _apiClient.get(
      '/owner/deployment/history',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['releases']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .toList();
  }

  Future<void> prepareRelease({
    required String version,
    required String environment,
    String? commitSha,
  }) async {
    await _apiClient.post(
      '/owner/deployment/releases',
      data: {
        'version': version,
        'environment':
            environment,
        'commitSha':
            commitSha,
      },
    );
  }
}
