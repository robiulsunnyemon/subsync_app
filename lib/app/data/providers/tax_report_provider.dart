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

  Future<Response> downloadTaxReportCsv(String year) async {
    return await _apiClient.get(
      '/reports/tax/csv',
      queryParameters: {'year': year},
    );
  }

  Future<Response> downloadTaxReportPdf(String year) async {
    return await _apiClient.get(
      '/reports/tax/pdf',
      queryParameters: {'year': year},
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
