library dartalog;


import 'package:uuid/uuid.dart' as UUID;

// Just a place to put some shared tools

const String UUID_REGEX_STRING_SNIPPET = r"[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";
const String UUID_REGEX_STRING = r"^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$";

final RegExp UUID_REGEX = new RegExp(UUID_REGEX_STRING);
// JSON-schema-related stuff

// Reserved field names
const String FIELD_UUID = "x_uuid";

// Constants to define the json hyper schema link names
// Field-related links
const String SCHEMA_LINK_GET_PROPERTIES = "get_properties";
const String SCHEMA_LINK_GET_PROPERTY = "get_property";
const String SCHEMA_LINK_CREATE_PROPERTY = "create_property";
const String SCHEMA_LINK_UPDATE_PROPERTY = "update_property";
const String SCHEMA_LINK_DELETE_PROPERTY = "delete_property";
// Others
const String SCHEMA_LINK_GET_CLASSES = "get_classes";
const String SCHEMA_LINK_GET_CLASS = "get_class";
const String SCHEMA_LINK_CREATE_CLASS = "create_class";
const String SCHEMA_LINK_UPDATE_CLASS = "update_class";
const String SCHEMA_LINK_DELETE_CLASS = "delete_class";

const String SCHEMA_LINK_GET_OBJECTS = "get_objects";
const String SCHEMA_LINK_GET_SETTINGS = "get_settings";
const String SCHEMA_LINK_NUKE = "nuke";



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