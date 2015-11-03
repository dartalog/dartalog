library tools;

import 'package:uuid/uuid.dart' as UUID;

const String UUID_REGEX_STRING_SNIPPET = r"[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";
const String UUID_REGEX_STRING = r"^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$";

final RegExp UUID_REGEX = new RegExp(UUID_REGEX_STRING);


bool isUuid(String uuid) {
  return UUID_REGEX.hasMatch(uuid);
}

String generateUuid() {
  UUID.Uuid uuid = new UUID.Uuid();
  var u4 = uuid.v4();
//  var temp = uuid.unparse(u4);
  return u4.toString();
}

/**
 * Checks if the [map] has a key matching the provided [key],
 * then checks if the key's value is [null], only whitespace, or blank.
 * Returns a [bool] indicating the status.
 */
bool keyExistsAndHasValue(Map map, String key) {
  if(!map.containsKey(key)) {
    return false;
  }
  if(map[key]==null) {
    return false;
  }
  return !isNullOrWhitespace(map[key]);
}

/**
 * Checks if the [input] String is [null], only whitespace, or blank,
 * returning a [true] if any of these conditions are met.
 * Returns a [false] otherwise.
 */
bool isNullOrWhitespace(String input) {
  if(input==null) {
    return true;
  }

  if(input.trim()=="") {
    return true;
  }

  return false;
}

String formatUuid(String input) {
  StringBuffer output = new StringBuffer();
  if(input.length<32) {
    throw new Exception("UUID too short: ${input}");
  }
  output.write(input.substring(0,8));
  output.write("-");
  output.write(input.substring(8,12));
  output.write("-");
  output.write(input.substring(12,16));
  output.write("-");
  output.write(input.substring(16,20));
  output.write("-");
  output.write(input.substring(20,32));
  return output.toString();
}