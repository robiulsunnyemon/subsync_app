import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/bank_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class BankConnectionController extends GetxController {
  
  final BankProvider _provider = BankProvider();
  final searchQuery = ''.obs;
  
  final popularBanks = [
    {'name': 'Revolut', 'type': 'Global Fintech', 'icon': 'R'},
    {'name': 'Monzo', 'type': 'United Kingdom', 'icon': 'M'},
    {'name': 'Wise', 'type': 'International', 'icon': 'W'},
    {'name': 'N26', 'type': 'Germany', 'icon': 'N'},
    {'name': 'Barclays', 'type': 'United Kingdom', 'icon': 'B'},
    {'name': 'Deutsche Bank', 'type': 'Germany', 'icon': 'D'},
  ].obs;

  final allInstitutions = [
    {'letter': 'A', 'banks': ['ABN AMRO', 'Allied Irish Banks (AIB)']},
    {'letter': 'B', 'banks': ['Banco Santander', 'BNP Paribas']},
    {'letter': 'C', 'banks': ['Crédit Agricole', 'Commerzbank']},
    {'letter': 'D', 'banks': ['Danske Bank']},
  ].obs;

  void connectBank(String bankName) {
    // Navigate to auth screen for this bank
    Get.toNamed('/bank-connection/auth', arguments: bankName);
  }

  void agreeAndContinue() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // In a real flow, the providerName should be Tink or the specific bank
      final response = await _provider.getAuthLink('TINK');
      Get.back(); // close dialog
      
      if (response.statusCode == 200 && response.data['authUrl'] != null) {
        String authUrl = response.data['authUrl'];
        debugPrint("Launching Bank Auth URL: $authUrl");
        CustomSnackbar.showSuccess('Connecting', 'Redirecting to your bank securely...');
        
        // Mock returning after success
        Get.offAllNamed('/dashboard');
      }
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to initiate connection';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }
}
