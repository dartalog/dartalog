/// Provides the various values of available user privileges, and helper functions to aid in comparing them/
abstract class UserPrivilege {
  static const String none = "none";
  static const String authenticated = "authenticated";
  static const String patron = "patron";
  static const String checkout = "checkout";
  static const String curator = "curator";
  static const String admin = "admin"; // Implies all other privileges
  static final List<String> values = <String>[patron, checkout, curator, admin];

  /// Determines whether the privilege that is [needed] is satisfied by the privilege the user [has].
  static bool evaluate(String needed, String has) {
    if (needed == none) return true;

    if (!values.contains(needed))
      throw new Exception("User privilege $needed not recognized");
    if (!values.contains(has))
      throw new Exception("User privelege $has not recognized");
    return values.indexOf(needed) <= values.indexOf(has);
  }
}
