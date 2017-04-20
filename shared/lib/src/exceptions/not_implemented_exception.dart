class NotImplementedException implements Exception {
  String message;
  NotImplementedException([this.message = ""]);
  @override
  String toString() => message;
}
