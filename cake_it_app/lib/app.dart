import 'package:cake_it_app/features/cakes/presentation/pages/cake_details_page.dart';
import 'package:cake_it_app/features/cakes/presentation/pages/cake_list_page.dart';
import 'package:cake_it_app/features/settings/settings/settings_controller.dart';
import 'package:cake_it_app/features/settings/settings/settings_view.dart';
import 'package:cake_it_app/localization/app_localizations.dart';
import 'package:flutter/material.dart';



/// The Widget that configures your application.
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

          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: CakeListView.routeName,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case CakeDetailsView.routeName:
                    return const CakeDetailsView();
                  case CakeListView.routeName:
                  default:
                    return const CakeListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
