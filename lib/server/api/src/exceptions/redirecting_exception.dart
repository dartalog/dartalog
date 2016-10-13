class RedirectingException implements  Exception {
  String old_id, new_id;
  RedirectingException(this.old_id, this.new_id);
}

