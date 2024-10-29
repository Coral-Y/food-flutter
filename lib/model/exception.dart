class ApiException {
  final int code;
  String message;

  ApiException(this.code, this.message);

  @override
  String toString() {
    return 'ApiException (Code: $code): $message';
  }
}
