import 'dart:ui';

import 'package:cake_it_app/core/app_routes.dart';
import 'package:cake_it_app/core/extensions.dart';
import 'package:cake_it_app/core/route_generator.dart';
import 'package:cake_it_app/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import 'features/settings/presentation/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // global error handling for uncaught exceptions
  FlutterError.onError = (FlutterErrorDetails details) {
    // log error with stack trace
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');

    // in production, send to crash reporting service
    // example: FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  // handle errors outside Flutter boundary
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    debugPrint('Stack trace: $stack');
    return true; // the error was handled
  };

  // initialise settings - removed SettingsService dependency
  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settingsController.locale,
          onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings, settingsController),
          builder: (context, child) {
            // global error boundary - catches widget build errors
            ErrorWidget.builder = (FlutterErrorDetails details) {
              return Scaffold(
                appBar: AppBar(title: const Text('Oops!')),
                body: const Center(
                  child: Text('Something went wrong. Please restart the app.'),
                ),
              );
            };
            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
