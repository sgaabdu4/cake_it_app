import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:cake_it_app/core/extensions.dart';
import 'package:flutter/cupertino.dart';
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
            ThemeSelector(controller: controller),
            const SizedBox(height: 24),
            Text(l10n.language),
            const SizedBox(height: 8),
            LanguageSelector(controller: controller),
          ],
        ),
      ),
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isApplePlatform = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    const modes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final modeNames = [l10n.systemTheme, l10n.lightTheme, l10n.darkTheme];

    if (isApplePlatform) {
      return _CupertinoThemeSelector(
        controller: controller,
        modes: modes,
        modeNames: modeNames,
      );
    }

    return DropdownButton<ThemeMode>(
      value: controller.themeMode,
      onChanged: controller.updateThemeMode,
      isExpanded: true,
      items: modes.asMap().entries.map((entry) {
        return DropdownMenuItem(
          value: entry.value,
          child: Text(modeNames[entry.key]),
        );
      }).toList(),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isApplePlatform = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    final locales = [null, const Locale('en'), const Locale('ar')];
    final localeNames = [l10n.systemLanguage, l10n.english, l10n.arabic];

    if (isApplePlatform) {
      return _CupertinoLanguageSelector(
        controller: controller,
        locales: locales,
        localeNames: localeNames,
      );
    }

    return DropdownButton<Locale?>(
      value: controller.locale,
      onChanged: controller.updateLocale,
      isExpanded: true,
      items: locales.asMap().entries.map((entry) {
        return DropdownMenuItem(
          value: entry.value,
          child: Text(localeNames[entry.key]),
        );
      }).toList(),
    );
  }
}

class _CupertinoThemeSelector extends StatelessWidget {
  const _CupertinoThemeSelector({
    required this.controller,
    required this.modes,
    required this.modeNames,
  });

  final SettingsController controller;
  final List<ThemeMode> modes;
  final List<String> modeNames;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = modes.indexOf(controller.themeMode);
    final currentThemeName =
        currentIndex >= 0 ? modeNames[currentIndex] : modeNames[0];

    return CupertinoButton(
      padding: const EdgeInsets.all(16),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currentThemeName,
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: CupertinoColors.systemGrey.resolveFrom(context),
            size: 20,
          ),
        ],
      ),
      onPressed: () => _showThemePicker(context, l10n),
    );
  }

  void _showThemePicker(BuildContext context, dynamic l10n) {
    showCupertinoModalPopup<ThemeMode>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(l10n.theme),
        actions: modes.asMap().entries.map((entry) {
          final index = entry.key;
          final mode = entry.value;
          final name = modeNames[index];

          return CupertinoActionSheetAction(
            isDefaultAction: mode == controller.themeMode,
            onPressed: () {
              controller.updateThemeMode(mode);
              Navigator.pop(context);
            },
            child: Text(name),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }
}

class _CupertinoLanguageSelector extends StatelessWidget {
  const _CupertinoLanguageSelector({
    required this.controller,
    required this.locales,
    required this.localeNames,
  });

  final SettingsController controller;
  final List<Locale?> locales;
  final List<String> localeNames;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = locales.indexOf(controller.locale);
    final currentLocaleName =
        currentIndex >= 0 ? localeNames[currentIndex] : localeNames[0];

    return CupertinoButton(
      padding: const EdgeInsets.all(16),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currentLocaleName,
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: CupertinoColors.systemGrey.resolveFrom(context),
            size: 20,
          ),
        ],
      ),
      onPressed: () => _showLanguagePicker(context, l10n),
    );
  }

  void _showLanguagePicker(BuildContext context, dynamic l10n) {
    showCupertinoModalPopup<Locale?>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(l10n.language),
        actions: locales.asMap().entries.map((entry) {
          final index = entry.key;
          final locale = entry.value;
          final name = localeNames[index];

          return CupertinoActionSheetAction(
            isDefaultAction: locale == controller.locale,
            onPressed: () {
              controller.updateLocale(locale);
              Navigator.pop(context);
            },
            child: Text(name),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }
}
