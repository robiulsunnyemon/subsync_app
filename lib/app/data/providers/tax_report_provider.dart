import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class TaxReportProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getReportData(String year) async {
    return await _apiClient.get(
      '/reports/tax',
      queryParameters: {'year': year},
    );
  }

  // To download a file, you'd usually use a launchUrl or Dio download.
  // For simplicity, we assume the backend returns a URL to the file,
  // or we launch the endpoint directly in a browser with the auth token.
  Future<Response> generateReportFile(String year, String format) async {
    return await _apiClient.get(
      '/reports/tax/$format',
      queryParameters: {'year': year},
    );
  }
}
