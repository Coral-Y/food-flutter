class ApiException {
  final int code;

  String message;

  ApiException(this.code, this.message);
}
