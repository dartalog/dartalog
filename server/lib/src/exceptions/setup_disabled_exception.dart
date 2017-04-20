class SetupDisabledException implements Exception {
  String message = "Setup is disabled, delete lock file to re-enable";

  @override
  String toString() => message;
}
