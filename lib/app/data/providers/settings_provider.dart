import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class SettingsProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getProfile() async {
    return await _apiClient.get('/settings/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _apiClient.put('/settings/profile', data: data);
  }
}
