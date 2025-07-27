import 'package:flutter/material.dart';
import 'package:cake_it_app/core/app_routes.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/presentation/views/cake_details_view.dart';
import 'package:cake_it_app/features/cakes/presentation/views/cake_list_view.dart';
import 'package:cake_it_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:cake_it_app/features/settings/presentation/views/settings_view.dart';
import 'package:cake_it_app/core/extensions.dart';

// type-safe routing - replaces navigator.pushNamed() string routing from initial repo
class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    SettingsController settingsController,
  ) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const CakeListView(),
          settings: settings,
        );

      case AppRoutes.cakeDetails:
        final cake = settings.arguments as Cake?;
        return MaterialPageRoute(
          builder: (_) => const CakeDetailsView(),
          settings: RouteSettings(
            name: settings.name,
            arguments: cake,
          ),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsView(controller: settingsController),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = context.l10n;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.notFound)),
              body: Center(
                child: Text(l10n.viewNotFound),
              ),
            );
          },
        );
    }
  }
}

// helper methods for type-safe navigation
class AppNavigator {
  static Future<T?> pushCakeDetails<T>(BuildContext context, Cake cake) {
    return Navigator.pushNamed<T>(
      context,
      AppRoutes.cakeDetails,
      arguments: cake,
    );
  }

  static Future<T?> pushSettings<T>(BuildContext context) {
    return Navigator.pushNamed<T>(context, AppRoutes.settings);
  }

  // pushHome (Cake List) not needed as it's a default route
}
