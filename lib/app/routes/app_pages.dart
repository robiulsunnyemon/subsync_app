import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/signup/signup_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/otp/otp_binding.dart';
import '../modules/otp/otp_view.dart';
import '../modules/forgot_password/forgot_password_binding.dart';
import '../modules/forgot_password/forgot_password_view.dart';
import '../modules/reset_password/reset_password_binding.dart';
import '../modules/reset_password/reset_password_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/bank_connection/bindings/bank_connection_binding.dart';
import '../modules/bank_connection/views/connect_bank_view.dart';
import '../modules/bank_connection/views/auth_bank_view.dart';
import '../modules/subscriptions/bindings/subscriptions_binding.dart';
import '../modules/subscriptions/views/subscriptions_view.dart';
import '../modules/subscriptions/views/subscription_details_view.dart';
import '../modules/tax_report/bindings/tax_report_binding.dart';
import '../modules/tax_report/views/tax_report_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/account_profile_view.dart';
import '../modules/settings/views/notification_settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BANK_CONNECTION,
      page: () => const ConnectBankView(),
      binding: BankConnectionBinding(),
    ),
    GetPage(
      name: _Paths.BANK_CONNECTION_AUTH,
      page: () => const AuthBankView(),
      binding: BankConnectionBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTIONS,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION_DETAILS,
      page: () => const SubscriptionDetailsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: _Paths.TAX_REPORT,
      page: () => const TaxReportView(),
      binding: TaxReportBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const AccountProfileView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SETTINGS,
      page: () => const NotificationSettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.BANK_CALLBACK,
      page: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
  ];
}
