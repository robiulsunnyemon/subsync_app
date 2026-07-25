import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/modules/dashboard/views/dashboard_view.dart';
import 'package:subsync/app/modules/subscriptions/views/subscriptions_view.dart';
import 'package:subsync/app/modules/bank_connection/views/connect_bank_view.dart';
import 'package:subsync/app/modules/tax_report/views/tax_report_view.dart';
import 'package:subsync/app/modules/settings/views/account_profile_view.dart';

class BottomNavigationController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget> pages = [
    const DashboardView(),
    const SubscriptionsView(),
    const ConnectBankView(),
    const TaxReportView(),
    const AccountProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
