/// {@template kite_api_exception}
/// Exception thrown when an error occurs during an operation with the Kite API.
/// {@endtemplate}
class KiteApiException implements Exception {
  /// {@macro kite_api_exception}
  const KiteApiException(this.message);

  /// Exception message.
  final String message;
}
