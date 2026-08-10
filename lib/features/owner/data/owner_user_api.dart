import '../../../core/network/api_client.dart';

class OwnerUserApi {
  OwnerUserApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>>
      list({
    String search = '',
    String? role,
    String? status,
    int page = 1,
  }) async {
    final response =
        await _apiClient.get(
      '/owner/users',
      queryParameters: {
        if (search.isNotEmpty)
          'search': search,
        if (role != null)
          'role': role,
        if (status != null)
          'status': status,
        'page': page,
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    return body['data']
            as Map<String, dynamic>? ??
        const {};
  }

  Future<void> updateStatus({
    required String userId,
    required String status,
  }) async {
    await _apiClient.patch(
      '/owner/users/$userId/status',
      data: {
        'status': status,
      },
    );
  }

  Future<void> revokeSessions(
    String userId,
  ) async {
    await _apiClient.post(
      '/owner/users/$userId/revoke-sessions',
    );
  }
}
