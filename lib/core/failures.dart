// custom error handling - replaces generic exception catching from initial repo
class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => 'Failure: $message';
}
