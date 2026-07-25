import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class SettingsProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getProfile() async {
    return await _apiClient.get('/users/me');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _apiClient.put('/users/me', data: data);
  }

  Future<Response> uploadProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return await _apiClient.post('/users/me/profile-image', data: formData);
  }
}
