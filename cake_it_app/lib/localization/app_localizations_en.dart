// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '🎂CakeItApp🍰';

  @override
  String get notFound => 'Not Found';

  @override
  String get viewNotFound => 'Page not found';

  @override
  String failedToRefresh({required String error}) {
    return 'Failed to refresh: $error';
  }

  @override
  String get errorLoadingCakes => 'Error loading cakes';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get failedToRefreshCakes => 'Failed to refresh cakes';

  @override
  String get cakeDetails => 'Cake Details';

  @override
  String get noCakeData => 'No cake data provided';

  @override
  String get noDescriptionAvailable => 'No description available';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get requestTimeout => 'Request timeout';

  @override
  String serverError({required int statusCode}) {
    return 'Server error: $statusCode';
  }

  @override
  String networkError({required String error}) {
    return 'Network error: $error';
  }

  @override
  String failedToFetchCakes({required String error}) {
    return 'Failed to fetch cakes: $error';
  }
}
