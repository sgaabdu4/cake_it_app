import 'package:flutter/material.dart';

import 'app.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';

void main() async {
  // required for async initialisation
  WidgetsFlutterBinding.ensureInitialized();

  // initialise settings - removed SettingsService dependency
  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
