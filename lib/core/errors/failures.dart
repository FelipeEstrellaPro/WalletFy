/// Base failure class for the app.
abstract class AppFailure implements Exception {
  final String message;
  const AppFailure(this.message);
  @override
  String toString() => message;
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class OllamaFailure extends AppFailure {
  const OllamaFailure(super.message);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}
