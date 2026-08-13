import '../../../core/network/api_client.dart';
import '../domain/user_session.dart';

class SessionApi {
  SessionApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<UserSession>>
      list({
    String? currentSessionId,
  }) async {
    final response =
        await _apiClient.get(
      '/sessions',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['sessions']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .map(
          (item) =>
              UserSession.fromJson(
            item,
            currentSessionId:
                currentSessionId,
          ),
        )
        .toList();
  }

  Future<void> revoke(
    String sessionId,
  ) async {
    await _apiClient.delete(
      '/sessions/$sessionId',
    );
  }

  Future<void>
      revokeOthers() async {
    await _apiClient.post(
      '/sessions/revoke-others',
    );
  }
}
