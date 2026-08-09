import '../../../core/network/api_client.dart';
import '../domain/audit_event.dart';

class AuditApi {
  AuditApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AuditEvent>>
      list({
    String? category,
    String? action,
  }) async {
    final response =
        await _apiClient.get(
      '/owner/audit',
      queryParameters: {
        if (category != null)
          'category': category,
        if (action != null)
          'action': action,
        'limit': 100,
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['logs']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .map(
          AuditEvent.fromJson,
        )
        .toList();
  }
}
