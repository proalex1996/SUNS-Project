
class UnauthorizedAccessException implements Exception {
  final String message;

  UnauthorizedAccessException(this.message);

  @override
  String toString() => message;
}
