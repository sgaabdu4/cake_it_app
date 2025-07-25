import 'package:cake_it_app/core/app_routes.dart';
import 'package:cake_it_app/features/cakes/presentation/pages/cake_details_page.dart';
import 'package:cake_it_app/features/cakes/presentation/pages/cake_list_page.dart';
import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:cake_it_app/features/settings/presentation/pages/settings_view.dart';
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
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          routes: {
            AppRoutes.home: (context) => const CakeListView(),
            AppRoutes.cakeDetails: (context) => const CakeDetailsView(),
            AppRoutes.settings: (context) => SettingsView(controller: settingsController),
          },
        );
      },
    );
  }
}
