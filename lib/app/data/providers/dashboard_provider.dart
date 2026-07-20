import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class DashboardProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getDashboardSummary() async {
    return await _apiClient.get('/dashboard/summary');
  }
}
