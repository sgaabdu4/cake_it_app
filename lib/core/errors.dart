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

class ServerError implements AppError {
  final int statusCode;

  const ServerError(this.statusCode);

  @override
  String getLocalizedMessage(AppLocalizations l10n) =>
      l10n.serverError(statusCode: statusCode);
}

class NetworkError implements AppError {
  final String message;

  const NetworkError(this.message);

  @override
  String getLocalizedMessage(AppLocalizations l10n) =>
      l10n.networkError(error: message);
}
