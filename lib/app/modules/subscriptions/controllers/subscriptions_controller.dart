import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/subscription_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

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
          
          final String backendType = map['type'] ?? 'OTHER';
          String category = 'Other';
          if (backendType == 'SOFTWARE') {
            category = 'Software';
          } else if (backendType == 'MARKETING') {
            category = 'Marketing';
          } else if (backendType == 'ENTERTAINMENT') {
            category = 'Entertainment';
          } else {
            category = backendType.toString().substring(0, 1) + backendType.toString().substring(1).toLowerCase();
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
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to cancel subscription';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }
}
