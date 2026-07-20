import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/bank_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class BankConnectionController extends GetxController {
  
  final BankProvider _provider = BankProvider();
  final searchQuery = ''.obs;
  
  final isLoading = false.obs;
  final selectedCountry = 'GB'.obs;

  final countries = [
    {'code': 'GB', 'name': 'United Kingdom'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'ES', 'name': 'Spain'},
    {'code': 'IT', 'name': 'Italy'},
    {'code': 'NL', 'name': 'Netherlands'},
    {'code': 'SE', 'name': 'Sweden'},
  ].obs;

  final popularBanks = [].obs;
  final allInstitutions = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanksForCountry(selectedCountry.value);
  }

  void changeCountry(String code) {
    selectedCountry.value = code;
    fetchBanksForCountry(code);
  }

  Future<void> fetchBanksForCountry(String countryCode) async {
    try {
      isLoading.value = true;
      final response = await _provider.getProviders(countryCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        // Group banks alphabetically
        Map<String, List<Map<String, dynamic>>> grouped = {};
        for (var item in data) {
          String name = item['displayName'] ?? item['name'] ?? 'Unknown';
          String letter = name[0].toUpperCase();
          if (!grouped.containsKey(letter)) {
            grouped[letter] = [];
          }
          grouped[letter]!.add({
            'name': name,
            'type': item['type'] ?? 'Bank',
            'icon': item['icon'] ?? letter,
          });
        }
        
        // Sort and map to expected format
        var sortedKeys = grouped.keys.toList()..sort();
        allInstitutions.value = sortedKeys.map((k) => {
          'letter': k,
          'banks': grouped[k],
        }).toList();

        // Just take the first few as popular for now
        if (data.length > 6) {
           popularBanks.value = data.sublist(0, 6).map((item) => {
             'name': item['displayName'] ?? item['name'],
             'type': item['type'] ?? 'Bank',
             'icon': item['icon'] ?? (item['displayName'] ?? item['name'])[0].toUpperCase(),
           }).toList();
        } else {
           popularBanks.value = data.map((item) => {
             'name': item['displayName'] ?? item['name'],
             'type': item['type'] ?? 'Bank',
             'icon': item['icon'] ?? (item['displayName'] ?? item['name'])[0].toUpperCase(),
           }).toList();
        }
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch banks for this country');
    } finally {
      isLoading.value = false;
    }
  }

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
