import 'package:cake_it_app/core/app_routes.dart';
import 'package:cake_it_app/core/route_generator.dart';
import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:cake_it_app/localization/app_localizations.dart';
import 'package:flutter/material.dart';

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
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings, settingsController),
        );
      },
    );
  }
}
