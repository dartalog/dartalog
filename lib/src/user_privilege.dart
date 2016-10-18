class UserPrivilege {
  static const String none = "none";
  static const String authenticated = "authenticated";
  static const String patron = "patron";
  static const String checkout = "checkout";
  static const String curator = "curator";
  static const String admin = "admin"; // Implies all other privileges
  static final List<String> values = <String>[patron, checkout, curator, admin];

  static bool evaluate(String needed, String have) {
    if (needed == none) return true;

    if (!values.contains(needed))
      throw new Exception("User type $needed not recognized");
    if (!values.contains(have))
      throw new Exception("User type $have not recognized");
    return values.indexOf(needed) <= values.indexOf(have);
  }
}
