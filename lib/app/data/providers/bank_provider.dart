import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class BankProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getAuthLink(String provider, {String market = 'GB'}) async {
    return await _apiClient.get(
      '/banks/auth-link',
      queryParameters: {'provider': provider, 'market': market},
    );
  }

  Future<Response> getProviders(String countryCode) async {
    return await _apiClient.get(
      '/banks/providers',
      queryParameters: {'countryCode': countryCode},
    );
  }

  Future<Response> handleCallback({
    required String code,
    required String institutionId,
    required String institutionName,
  }) async {
    return await _apiClient.post(
      '/banks/callback',
      data: {
        'code': code,
        'institutionId': institutionId,
        'institutionName': institutionName,
      },
    );
  }

  Future<Response> getMyConnections() async {
    return await _apiClient.get('/banks/my-connections');
  }

  Future<Response> disconnectBank(String id) async {
    return await _apiClient.delete('/banks/$id');
  }

  Future<Response> getTransactions() async {
    return await _apiClient.get('/banks/transactions');
  }
}
