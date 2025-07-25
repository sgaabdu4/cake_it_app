/// Base class for all failures in the application
abstract class Failure {
  const Failure(this.message);
  
  final String message;
  
  @override
  String toString() => 'Failure: $message';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Parsing-related failures
class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

/// Generic application failures
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}
