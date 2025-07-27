import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:cake_it_app/core/extensions.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.theme),
            const SizedBox(height: 8),
            DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.systemTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.lightTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.darkTheme),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.language),
            const SizedBox(height: 8),
            DropdownButton<Locale?>(
              value: controller.locale,
              onChanged: controller.updateLocale,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.systemLanguage),
                ),
                const DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                const DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('العربية'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
