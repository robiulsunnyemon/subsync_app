import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/subscription_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:subsync/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:subsync/app/modules/tax_report/controllers/tax_report_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SubscriptionsController extends GetxController {
  
  final SubscriptionProvider _provider = SubscriptionProvider();

  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final isLoading = true.obs;
  
  final subscriptions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  Future<void> fetchSubscriptions() async {
    isLoading.value = true;
    try {
      final response = await _provider.getAllSubscriptions();
      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data;
        subscriptions.value = rawList.map((item) {
          final Map<String, dynamic> map = Map<String, dynamic>.from(item);
          final String merchantName = map['merchantName'] ?? 'Subscription';
          final String firstLetter = merchantName.isNotEmpty ? merchantName[0].toUpperCase() : 'S';
          
          final String backendType = map['type'] ?? 'UNCATEGORIZED';
          String category = 'Uncategorized';
          if (backendType == 'BUSINESS') {
            category = 'Business';
          } else if (backendType == 'PERSONAL') {
            category = 'Personal';
          }

          final String statusStr = map['status'] == 'ACTIVE' ? 'Active' : 'Cancelled';

          return {
            'id': map['id'],
            'name': merchantName,
            'amount': (map['amount'] as num?)?.toDouble() ?? 0.0,
            'currency': map['currency'] ?? 'EUR',
            'cycle': map['cycle'] ?? 'MONTHLY',
            'nextBilling': map['nextBillingDate'] ?? '',
            'tags': [category],
            'category': category,
            'icon': firstLetter,
            'status': statusStr,
          };
        }).toList();
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Failed to load subscriptions';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void openDetails(Map<String, dynamic> subscription) {
    Get.toNamed('/subscriptions/details', arguments: subscription);
  }

  Future<void> cancelSubscription(String id) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _provider.cancelSubscription(id);
      Get.back();
      CustomSnackbar.showSuccess('Success', 'Subscription cancelled successfully');
      fetchSubscriptions(); // Refresh list
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchDashboardData();
      }
      if (Get.isRegistered<TaxReportController>()) {
        Get.find<TaxReportController>().fetchReport();
      }
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to cancel subscription';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }

  Future<bool> updateCategory(String? id, String category) async {
    if (id == null || id.toString().isEmpty) return true;
    try {
      String typeParam = 'UNCATEGORIZED';
      if (category == 'Business') {
        typeParam = 'BUSINESS';
      } else if (category == 'Personal') {
        typeParam = 'PERSONAL';
      }
      await _provider.updateCategory(id.toString(), typeParam);
      CustomSnackbar.showSuccess('Updated', 'Category updated to $category');
      fetchSubscriptions();
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchDashboardData();
      }
      if (Get.isRegistered<TaxReportController>()) {
        Get.find<TaxReportController>().fetchReport();
      }
      return true;
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Failed to update category';
      CustomSnackbar.showError('Error', message);
      return false;
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to update category');
      return false;
    }
  }

  Future<void> downloadAndOpenInvoice(String? subscriptionId, String merchantName) async {
    if (subscriptionId == null || subscriptionId.toString().isEmpty) {
      CustomSnackbar.showError('Error', 'Invalid subscription ID');
      return;
    }

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
                  Text('Generating Tax Invoice...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _provider.downloadInvoice(subscriptionId.toString());
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final List<int> bytes = List<int>.from(response.data);
        final Directory dir = await getApplicationDocumentsDirectory();
        final String sanitizedName = merchantName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
        final String filePath = '${dir.path}/SubSync_Invoice_${sanitizedName}_${subscriptionId.toString().substring(0, 8)}.pdf';
        
        final File file = File(filePath);
        await file.writeAsBytes(bytes);

        CustomSnackbar.showSuccess('Success', 'Invoice downloaded and saved');
        await OpenFile.open(filePath);
      } else {
        CustomSnackbar.showError('Error', 'Failed to download invoice');
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      String message = 'Failed to download invoice';
      if (e.response?.data != null) {
        try {
          if (e.response!.data is Map) {
            message = e.response!.data['message'] ?? message;
          } else if (e.response!.data is List<int>) {
            final String jsonStr = String.fromCharCodes(e.response!.data as List<int>);
            if (jsonStr.contains('"message":')) {
              final int start = jsonStr.indexOf('"message":') + 10;
              final int end = jsonStr.indexOf('"', start + 1);
              if (start > 9 && end > start) {
                message = jsonStr.substring(start + 1, end);
              }
            }
          }
        } catch (_) {}
      }
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackbar.showError('Error', 'Failed to generate invoice file');
    }
  }
}
