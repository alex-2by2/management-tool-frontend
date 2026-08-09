import '../network/api_client.dart';
import 'remote_config_store.dart';

class RemoteConfigApi {
  RemoteConfigApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<RemoteConfigStore>
      fetch() async {
    final response =
        await _apiClient.get(
      '/config',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    final config =
        data['config']
            as Map<String, dynamic>? ??
        const {};

    return RemoteConfigStore(
      values: config,
    );
  }
}
