import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class BankProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getAuthLink(String provider) async {
    return await _apiClient.get(
      '/banks/auth-link',
      queryParameters: {'provider': provider},
    );
  }
}
