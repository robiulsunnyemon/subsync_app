import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/bank_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class BankConnectionController extends GetxController {
  
  final BankProvider _provider = BankProvider();
  final searchQuery = ''.obs;
  
  final isLoading = false.obs;
  final isConnecting = false.obs;
  final selectedCountry = 'GB'.obs;
  final selectedBankName = ''.obs;

  // Deep link listener
  StreamSubscription? _linkSubscription;
  final AppLinks _appLinks = AppLinks();

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
  final myConnections = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanksForCountry(selectedCountry.value);
    fetchMyConnections();
    _initDeepLinkListener();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // Deep Link Listener (listens for subsync://bank-callback)
  // ─────────────────────────────────────────────
  void _initDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'subsync' && uri.host == 'bank-callback') {
        _handleDeepLinkCallback(uri);
      }
    }, onError: (err) {
      debugPrint('Deep link error: $err');
    });
  }

  void _handleDeepLinkCallback(Uri uri) async {
    final code = uri.queryParameters['code'];
    final credentialsId = uri.queryParameters['credentialsId'];

    if (code == null && credentialsId == null) {
      CustomSnackbar.showError('Error', 'Bank connection failed. No code received.');
      return;
    }

    try {
      isConnecting.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await _provider.handleCallback(
        code: code ?? credentialsId ?? '',
        institutionId: credentialsId ?? 'unknown',
        institutionName: selectedBankName.value.isNotEmpty ? selectedBankName.value : 'Connected Bank',
      );

      Get.back(); // close loading dialog

      if (response.statusCode == 200) {
        await fetchMyConnections();
        CustomSnackbar.showSuccess('Connected! 🎉', '${selectedBankName.value} has been connected successfully.');
        Get.offAllNamed('/dashboard');
      }
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data?['message'] ?? 'Failed to complete connection';
      CustomSnackbar.showError('Connection Failed', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    } finally {
      isConnecting.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Fetch banks list by country
  // ─────────────────────────────────────────────
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
        
        var sortedKeys = grouped.keys.toList()..sort();
        allInstitutions.value = sortedKeys.map((k) => {
          'letter': k,
          'banks': grouped[k],
        }).toList();

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

  // ─────────────────────────────────────────────
  // Navigate to auth screen
  // ─────────────────────────────────────────────
  void connectBank(String bankName) {
    selectedBankName.value = bankName;
    Get.toNamed('/bank-connection/auth', arguments: bankName);
  }

  // ─────────────────────────────────────────────
  // Launch Tink auth URL in external browser
  // ─────────────────────────────────────────────
  void agreeAndContinue() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _provider.getAuthLink('TINK', market: selectedCountry.value);
      Get.back(); // close dialog
      
      if (response.statusCode == 200 && response.data['authUrl'] != null) {
        String authUrl = response.data['authUrl'];
        debugPrint("Launching Bank Auth URL: $authUrl");
        
        final uri = Uri.parse(authUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          // After this, Tink will redirect back via the deep link
          // which is handled by _handleDeepLinkCallback()
        } else {
          CustomSnackbar.showError('Error', 'Could not open the bank authorization page.');
        }
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

  // ─────────────────────────────────────────────
  // Fetch my connected banks
  // ─────────────────────────────────────────────
  Future<void> fetchMyConnections() async {
    try {
      final response = await _provider.getMyConnections();
      if (response.statusCode == 200) {
        myConnections.value = response.data as List;
      }
    } catch (e) {
      // Silently ignore - user might not have any connections
    }
  }

  // ─────────────────────────────────────────────
  // Disconnect a bank
  // ─────────────────────────────────────────────
  Future<void> disconnectBank(String connectionId, String bankName) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Disconnect Bank?'),
        content: Text('Are you sure you want to disconnect $bankName?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Disconnect', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await _provider.disconnectBank(connectionId);
      if (response.statusCode == 200) {
        await fetchMyConnections();
        CustomSnackbar.showSuccess('Done', '$bankName disconnected successfully.');
      }
    } on DioException catch (e) {
      String message = e.response?.data?['message'] ?? 'Failed to disconnect';
      CustomSnackbar.showError('Error', message);
    }
  }
}
