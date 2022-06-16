class Result<T> {
  T? data;
  bool? error;
  String? errorMessage;
  String? statusCode;

  Result({this.data, this.error, this.errorMessage, this.statusCode});
}
