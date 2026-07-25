import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/tax_report_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class TaxReportController extends GetxController {
  
  final TaxReportProvider _provider = TaxReportProvider();

  final selectedYear = DateTime.now().year.toString().obs;
  
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
      CustomSnackbar.showError('Error', 'Failed to fetch tax report data');
    } finally {
      isLoading.value = false;
    }
  }

  void changeYear(String year) {
    if (selectedYear.value != year) {
      selectedYear.value = year;
      fetchReport();
    }
  }

  Future<void> exportCsv() async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating CSV Report...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _provider.downloadTaxReportCsv(selectedYear.value);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final String csvContent = response.data.toString();
        final Directory dir = await getApplicationDocumentsDirectory();
        final String filePath = '${dir.path}/SubSync_Tax_Report_${selectedYear.value}.csv';
        
        final File file = File(filePath);
        await file.writeAsString(csvContent);

        CustomSnackbar.showSuccess('Success', 'CSV Report downloaded successfully');
        await OpenFile.open(filePath);
      } else {
        CustomSnackbar.showError('Error', 'Failed to generate CSV report');
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      String message = e.response?.data['message'] ?? 'Failed to download CSV report';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackbar.showError('Error', 'Failed to export CSV file');
    }
  }

  Future<void> generatePdf() async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating Annual PDF Tax Report...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _provider.downloadTaxReportPdf(selectedYear.value);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final List<int> bytes = List<int>.from(response.data);
        final Directory dir = await getApplicationDocumentsDirectory();
        final String filePath = '${dir.path}/SubSync_Annual_Tax_Report_${selectedYear.value}.pdf';
        
        final File file = File(filePath);
        await file.writeAsBytes(bytes);

        CustomSnackbar.showSuccess('Success', 'PDF Tax Report downloaded successfully');
        await OpenFile.open(filePath);
      } else {
        CustomSnackbar.showError('Error', 'Failed to generate PDF report');
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      String message = 'Failed to download PDF report';
      if (e.response?.data != null && e.response!.data is List<int>) {
        try {
          final String jsonStr = String.fromCharCodes(e.response!.data as List<int>);
          if (jsonStr.contains('"message":')) {
            final int start = jsonStr.indexOf('"message":') + 10;
            final int end = jsonStr.indexOf('"', start + 1);
            if (start > 9 && end > start) {
              message = jsonStr.substring(start + 1, end);
            }
          }
        } catch (_) {}
      }
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackbar.showError('Error', 'Failed to generate PDF file');
    }
  }
}
