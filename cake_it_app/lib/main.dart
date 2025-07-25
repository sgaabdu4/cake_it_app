import 'package:flutter/material.dart';

import 'app.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
