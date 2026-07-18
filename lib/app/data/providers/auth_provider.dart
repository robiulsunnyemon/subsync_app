import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class AuthProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(String email, String password) async {
    return await _apiClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> register(String fullName, String email, String password) async {
    return await _apiClient.post(
      '/auth/register',
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> verifyOtp(String email, String otp) async {
    return await _apiClient.post(
      '/auth/verify-otp',
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<Response> forgotPassword(String email) async {
    return await _apiClient.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      },
    );
  }

  Future<Response> resendOtp(String email) async {
    return await _apiClient.post(
      '/auth/resend-otp',
      data: {
        'email': email,
      },
    );
  }

  Future<Response> verifyResetOtp(String email, String otp) async {
    return await _apiClient.post(
      '/auth/verify-reset-otp',
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<Response> resetPassword(String token, String newPassword) async {
    return await _apiClient.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
  }

  Future<Response> socialLogin(String idToken, String provider) async {
    return await _apiClient.post(
      '/auth/social-login',
      data: {
        'idToken': idToken,
        'provider': provider,
      },
    );
  }

  Future<Response> logout() async {
    return await _apiClient.post('/auth/logout');
  }
}
