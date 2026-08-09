import '../../../core/network/api_client.dart';
import '../domain/api_key.dart';

class ApiKeyApi {
  ApiKeyApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<ApiKeyItem>>
      list() async {
    final response =
        await _apiClient.get(
      '/owner/api-keys',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['keys']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .map(
          ApiKeyItem.fromJson,
        )
        .toList();
  }

  Future<String> create({
    required String name,
    List<String> scopes =
        const [],
  }) async {
    final response =
        await _apiClient.post(
      '/owner/api-keys',
      data: {
        'name': name,
        'scopes': scopes,
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return data['key']
        .toString();
  }

  Future<void> revoke(
    String id,
  ) async {
    await _apiClient.delete(
      '/owner/api-keys/$id',
    );
  }
}
