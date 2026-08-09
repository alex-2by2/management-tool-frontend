import '../../../core/network/api_client.dart';
import '../../settings/domain/app_settings.dart';

class SettingsApi {
  SettingsApi({
    ApiClient? apiClient,
  }) : _apiClient =
            apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<AppSettings> get() async {
    final response =
        await _apiClient.get(
      '/owner/settings',
    );

    final body =
        response.data
            as Map<String, dynamic>;

    final data =
        body['data']
            as Map<String, dynamic>;

    return AppSettings.fromJson(
      data,
    );
  }

  Future<AppSettings> update({
    required String appName,
    required String supportEmail,
    required String supportUrl,
    required String logoUrl,
    required String primaryColor,
    required String maintenanceMessage,
    required String defaultTheme,
  }) async {
    final response =
        await _apiClient.patch(
      '/owner/settings',
      data: {
        'appName': appName,
        'supportEmail':
            supportEmail,
        'supportUrl':
            supportUrl,
        'logoUrl': logoUrl,
        'primaryColor':
            primaryColor,
        'maintenanceMessage':
            maintenanceMessage,
        'defaultTheme':
            defaultTheme,
      },
    );

    final body =
        response.data
            as Map<String, dynamic>;

    return AppSettings.fromJson(
      body['data']
          as Map<String, dynamic>,
    );
  }
}
