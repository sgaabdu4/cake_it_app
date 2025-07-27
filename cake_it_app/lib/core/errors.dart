import '../localization/app_localizations.dart';

// structured error objects with localisation support for clean architecture
abstract class AppError {
  String getLocalizedMessage(AppLocalizations l10n);
}

class NetworkTimeoutError implements AppError {
  @override
  String getLocalizedMessage(AppLocalizations l10n) => l10n.requestTimeout;
}

class UnexpectedError implements AppError {
  @override
  String getLocalizedMessage(AppLocalizations l10n) => l10n.unexpectedError;
}

class RefreshFailedError implements AppError {
  @override
  String getLocalizedMessage(AppLocalizations l10n) =>
      l10n.failedToRefreshCakes;
}
