import '../../../core/network/api_client.dart';

class OwnerDashboardApi {
  OwnerDashboardApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>>
      getOverview() async {
    final response =
        await _apiClient.get(
      '/owner/overview',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    return body['data']
            as Map<String, dynamic>? ??
        const {};
  }
}
