import 'package:flutter/material.dart';
import 'package:cake_it_app/localization/app_localizations.dart';

// context extensions for cleaner route argument access
extension BuildContextExtensions on BuildContext {
  T? routeArguments<T>() {
    return ModalRoute.of(this)?.settings.arguments as T?;
  }

  /// get localised strings - cleaner than AppLocalizations.of(context)!
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
