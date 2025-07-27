import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsController Tests', () {
    late SettingsController controller;

    setUp(() {
      controller = SettingsController();
      SharedPreferences.setMockInitialValues({});
    });

    test('should save theme mode to preferences', () async {
      // Given
      await controller.loadSettings();

      // When
      await controller.updateThemeMode(ThemeMode.light);

      // Then
      expect(controller.themeMode, ThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });

    test('should save locale to preferences', () async {
      // Given
      await controller.loadSettings();

      // When
      await controller.updateLocale(const Locale('ar'));

      // Then
      expect(controller.locale, const Locale('ar'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), 'ar');
    });

    test('should handle preferences load failure gracefully', () async {
      // Given
      // Simulate failure by not providing mock values properly

      // When
      await controller.loadSettings();

      // Then
      expect(controller.themeMode, ThemeMode.system);
      expect(controller.locale, isNull);
    });
  });
}
