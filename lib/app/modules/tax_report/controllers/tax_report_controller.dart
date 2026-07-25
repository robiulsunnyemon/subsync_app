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

  late final Rx<DateTime> startDate;
  late final Rx<DateTime> endDate;

  final selectedPreset = 'Calendar Year'.obs;
  
  final totalBusinessDeductions = 0.0.obs;
  final isLoading = true.obs;
  
  final businessSubscriptions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    startDate = DateTime(now.year, 1, 1).obs;
    endDate = DateTime(now.year, 12, 31).obs;
    fetchReport();
  }

  String formatDateApi(DateTime dt) {
    String month = dt.month.toString().padLeft(2, '0');
    String day = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$month-$day';
  }

  Future<void> fetchReport() async {
    isLoading.value = true;
    try {
      final sStr = formatDateApi(startDate.value);
      final eStr = formatDateApi(endDate.value);
      
      final response = await _provider.getReportData(sStr, eStr);
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

  void setCalendarYear() {
    final now = DateTime.now();
    startDate.value = DateTime(now.year, 1, 1);
    endDate.value = DateTime(now.year, 12, 31);
    selectedPreset.value = 'Calendar Year';
    fetchReport();
  }

  void setUKTaxYear() {
    final now = DateTime.now();
    int year = now.year;
    if (now.month < 4 || (now.month == 4 && now.day < 6)) {
      year = year - 1;
    }
    startDate.value = DateTime(year, 4, 6);
    endDate.value = DateTime(year + 1, 4, 5);
    selectedPreset.value = 'UK Tax Year';
    fetchReport();
  }

  Future<void> selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate.value, end: endDate.value),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Tax Period Range',
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      selectedPreset.value = 'Custom';
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

      final sStr = formatDateApi(startDate.value);
      final eStr = formatDateApi(endDate.value);

      final response = await _provider.downloadTaxReportCsv(sStr, eStr);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final String csvContent = response.data.toString();
        final Directory dir = await getApplicationDocumentsDirectory();
        final String filePath = '${dir.path}/SubSync_Tax_Report_${sStr}_to_${eStr}.csv';
        
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
                  Text('Generating PDF Tax Report...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final sStr = formatDateApi(startDate.value);
      final eStr = formatDateApi(endDate.value);

      final response = await _provider.downloadTaxReportPdf(sStr, eStr);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final List<int> bytes = List<int>.from(response.data);
        final Directory dir = await getApplicationDocumentsDirectory();
        final String filePath = '${dir.path}/SubSync_Tax_Report_${sStr}_to_${eStr}.pdf';
        
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
