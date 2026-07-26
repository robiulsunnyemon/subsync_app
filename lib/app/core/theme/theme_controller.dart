import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final _box = GetStorage();
  final _key = 'themeMode';

  final rxThemeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final savedMode = _box.read<String>(_key);
    if (savedMode == 'dark') {
      rxThemeMode.value = ThemeMode.dark;
    } else if (savedMode == 'light') {
      rxThemeMode.value = ThemeMode.light;
    } else {
      rxThemeMode.value = ThemeMode.system;
    }
  }

  ThemeMode get themeMode => rxThemeMode.value;

  bool get isDarkMode {
    if (rxThemeMode.value == ThemeMode.dark) return true;
    if (rxThemeMode.value == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  String get currentThemeName {
    if (rxThemeMode.value == ThemeMode.dark) return 'Dark Mode 🌙';
    if (rxThemeMode.value == ThemeMode.light) return 'Light Mode ☀️';
    return 'System Default 💻';
  }

  void changeThemeMode(ThemeMode mode) {
    rxThemeMode.value = mode;
    String modeStr = 'system';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.light) modeStr = 'light';

    _box.write(_key, modeStr);
    Get.changeThemeMode(mode);
    
    // Instantly rebuild the entire app widget tree across all open screens!
    Get.forceAppUpdate();
  }
}
