import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // load theme mode
      final themeModeString = prefs.getString(_themeModeKey);
      _themeMode = switch (themeModeString) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.system,
      };

      // load locale
      final localeString = prefs.getString(_localeKey);
      _locale = localeString != null ? Locale(localeString) : null;

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load settings: $e');
      // load failed - use defaults
      _themeMode = ThemeMode.system;
      _locale = null;
      notifyListeners();
    }
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = switch (newThemeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

      await prefs.setString(_themeModeKey, themeModeString);
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
      // save failed - UI updated but not persisted
      return;
    }
  }

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == _locale) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      if (newLocale != null) {
        await prefs.setString(_localeKey, newLocale.languageCode);
      } else {
        await prefs.remove(_localeKey);
      }
    } catch (e) {
      debugPrint('Failed to save locale: $e');
      // save failed - UI updated but not persisted
      return;
    }
  }
}
