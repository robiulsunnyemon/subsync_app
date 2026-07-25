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
          
          final String category = _getCategoryForMerchant(merchantName);

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

  String _getCategoryForMerchant(String merchantName) {
    final name = merchantName.toLowerCase();
    
    if (name.contains('netflix') || 
        name.contains('spotify') || 
        name.contains('itunes') || 
        name.contains('youtube') || 
        name.contains('disney') || 
        name.contains('prime video') || 
        name.contains('hulu')) {
      return 'Entertainment';
    }
    
    if (name.contains('aws') || 
        name.contains('amazon') || 
        name.contains('google cloud') || 
        name.contains('github') || 
        name.contains('slack') || 
        name.contains('zoom') || 
        name.contains('currys') || 
        name.contains('adobe') ||
        name.contains('jira')) {
      return 'Software';
    }
    
    if (name.contains('ads') || 
        name.contains('facebook') || 
        name.contains('mailchimp') || 
        name.contains('hubspot') || 
        name.contains('buffer') ||
        name.contains('marketing')) {
      return 'Marketing';
    }
    
    return 'Other';
  }
}
