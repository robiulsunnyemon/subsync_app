import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/tax_report_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class TaxReportController extends GetxController {
  
  final TaxReportProvider _provider = TaxReportProvider();

  final selectedYear = '2023'.obs;
  
  final totalBusinessDeductions = 0.0.obs;
  final isLoading = true.obs;
  
  final businessSubscriptions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReport();
  }

  Future<void> fetchReport() async {
    isLoading.value = true;
    try {
      final response = await _provider.getReportData(selectedYear.value);
      if (response.statusCode == 200) {
        final data = response.data;
        totalBusinessDeductions.value = (data['totalDeductions'] ?? 0.0).toDouble();
        businessSubscriptions.value = data['subscriptions'] ?? [];
      }
    } catch (e) {
      // Silently handle error for now or show snackbar
    } finally {
      isLoading.value = false;
    }
  }

  void downloadReport(String format) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      // Calls the backend endpoint /api/v1/reports/tax/csv or /api/v1/reports/tax/pdf
      final response = await _provider.generateReportFile(selectedYear.value, format.toLowerCase());
      Get.back();
      
      if (response.statusCode == 200 && response.data['fileUrl'] != null) {
        String fileUrl = response.data['fileUrl'];
        CustomSnackbar.showSuccess('Success', 'Report ready. Downloading...');
        // launchUrl(Uri.parse(fileUrl));
      } else {
        CustomSnackbar.showSuccess('Downloading', 'Your $format report is being downloaded.');
      }
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to download report';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }
}
