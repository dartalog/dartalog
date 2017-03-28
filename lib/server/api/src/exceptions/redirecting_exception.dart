class RedirectingException implements Exception {
  String oldId, newId;
  RedirectingException(this.oldId, this.newId);
}
