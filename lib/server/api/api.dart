library api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypt/crypt.dart' as crypt;
import 'package:crypto/crypto.dart' as crypto;
import 'package:shelf_auth/shelf_auth.dart' ;
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/import/import.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/data_sources/data_sources.dart' as data_source;
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:rpc/rpc.dart';
import 'package:stack_trace/stack_trace.dart';

part 'package:dartalog/server/api/src/responses/item_listing_response.dart';
part 'src/dartalog_api.dart';
part 'src/exceptions/redirecting_exception.dart';
part 'src/requests/password_change_request.dart';
part 'src/requests/item_action_request.dart';
part 'src/requests/create_item_request.dart';
part 'src/requests/database_setup_request.dart';
part 'src/requests/update_item_request.dart';
part 'src/requests/bulk_item_action_request.dart';
part 'src/resources/a_id_resource.dart';
part 'src/resources/a_resource.dart';
part 'src/resources/collection_resource.dart';
part 'src/resources/field_resource.dart';
part 'src/resources/import_resource.dart';
part 'src/resources/setup_resource.dart';
part 'src/resources/item_copy_resource.dart';
part 'src/resources/item_resource.dart';
part 'src/resources/item_type_resource.dart';
part 'src/resources/preset_resource.dart';
part 'src/resources/user_resource.dart';
part 'src/responses/data_response.dart';
part 'src/responses/id_response.dart';

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