import 'package:rpc/rpc.dart';
export 'src/dartalog_api.dart';
export 'src/exceptions/redirecting_exception.dart';

const String API_COLLECTIONS_PATH = "collections";
const String API_COPIES_PATH = "copies";
const String API_FIELDS_PATH = "fields";
const String API_ACTIONS_PATH = "actions";
const String API_HISTORY_PATH = "history";
const String API_IMPORT_PATH = "import";
const String API_ITEM_TYPES_PATH = "item_types";
const String API_ITEMS_PATH = "items";
const String API_USERS_PATH = "users";
const String API_SETUP_PATH = "setup";


List<List<int>> convertFiles(List<MediaMessage> input) {
  List<List<int>> output = [];
  for(MediaMessage mm in input) {
    output.add(mm.bytes);
  }
  return output;
}