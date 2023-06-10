class UserFriendlyException implements Exception {
  final String message;
  final String detail;

  UserFriendlyException(this.message, [this.detail]);

  @override
  String toString() => message;
}
