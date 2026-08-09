import '../../../core/network/api_client.dart';
import '../domain/feature_flag.dart';

class FeatureFlagApi {
  FeatureFlagApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<FeatureFlag>>
      list() async {
    final response =
        await _apiClient.get(
      '/owner/features',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final items =
        data['features']
                as List<dynamic>? ??
            const [];

    return items
        .whereType<
            Map<String, dynamic>>()
        .map(
          FeatureFlag.fromJson,
        )
        .toList();
  }

  Future<FeatureFlag>
      update({
    required String key,
    required bool enabled,
  }) async {
    final response =
        await _apiClient.patch(
      '/owner/features/$key',
      data: {
        'enabled': enabled,
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return FeatureFlag.fromJson(
      data['feature']
          as Map<String, dynamic>,
    );
  }
}
