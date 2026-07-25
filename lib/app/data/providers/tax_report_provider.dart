import 'package:dio/dio.dart';
import 'package:subsync/app/core/network/api_client.dart';

class TaxReportProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getReportData(String startDate, String endDate) async {
    return await _apiClient.get(
      '/reports/tax',
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      },
    );
  }

  Future<Response> downloadTaxReportCsv(String startDate, String endDate) async {
    return await _apiClient.get(
      '/reports/tax/csv',
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      },
    );
  }

  Future<Response> downloadTaxReportPdf(String startDate, String endDate) async {
    return await _apiClient.get(
      '/reports/tax/pdf',
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      },
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
