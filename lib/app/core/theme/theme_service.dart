import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _modeKey = 'themeMode';

  ThemeMode get theme {
    final savedMode = _box.read<String>(_modeKey);
    if (savedMode == 'dark') {
      return ThemeMode.dark;
    } else if (savedMode == 'light') {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  String get currentThemeName {
    final savedMode = _box.read<String>(_modeKey);
    if (savedMode == 'dark') return 'Dark Mode 🌙';
    if (savedMode == 'light') return 'Light Mode ☀️';
    return 'System Default 💻';
  }

  bool get isDarkMode {
    final mode = theme;
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  void switchThemeMode(ThemeMode mode) {
    String modeStr = 'system';
    if (mode == ThemeMode.dark) {
      modeStr = 'dark';
    } else if (mode == ThemeMode.light) {
      modeStr = 'light';
    }

    _box.write(_modeKey, modeStr);
    Get.changeThemeMode(mode);
  }
}
