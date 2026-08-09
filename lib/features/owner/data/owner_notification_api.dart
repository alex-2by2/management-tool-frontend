import '../../../core/network/api_client.dart';

class OwnerNotificationApi {
  OwnerNotificationApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>>
      list() async {
    final response =
        await _apiClient.get(
      '/owner/notifications',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['notifications']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .toList();
  }

  Future<void> create({
    required String title,
    required String message,
    required String type,
    required String target,
    required String channel,
  }) async {
    await _apiClient.post(
      '/owner/notifications',
      data: {
        'title': title,
        'message': message,
        'type': type,
        'target': target,
        'channel': channel,
      },
    );
  }

  Future<void> disable(
    String id,
  ) async {
    await _apiClient.delete(
      '/owner/notifications/$id',
    );
  }
}
