import '../../../core/network/api_client.dart';
import '../domain/app_notification.dart';

class NotificationApi {
  NotificationApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AppNotification>>
      list() async {
    final response =
        await _apiClient.get(
      '/notifications',
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
        .map(
          AppNotification.fromJson,
        )
        .toList();
  }

  Future<int> unreadCount() async {
    final response =
        await _apiClient.get(
      '/notifications/unread-count',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return (data['count'] as num?)
            ?.toInt() ??
        0;
  }

  Future<void> markRead(
    String id,
  ) async {
    await _apiClient.patch(
      '/notifications/$id/read',
    );
  }

  Future<void> dismiss(
    String id,
  ) async {
    await _apiClient.patch(
      '/notifications/$id/dismiss',
    );
  }
}
