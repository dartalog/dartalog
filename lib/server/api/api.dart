library api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/import/import.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:rpc/rpc.dart';
import 'package:stack_trace/stack_trace.dart';

part 'src/dartalog_api.dart';
part 'src/data/a_data.dart';
part 'src/data/a_id_data.dart';
part 'src/data/field.dart';
part 'src/data/id_name_pair.dart';
part 'src/data/item.dart';
part 'src/data/item_copy.dart';
part 'src/data/collection.dart';
part 'src/data/item_listing.dart';
part 'src/data/item_type.dart';
part 'src/data/settings.dart';
part 'src/exceptions/data_validation_exception.dart';
part 'src/exceptions/redirecting_exception.dart';
part 'src/resources/a_resource.dart';
part 'src/resources/field_resource.dart';
part 'src/resources/import_resource.dart';
part 'src/resources/item_resource.dart';
part 'src/resources/collection_resource.dart';
part 'src/resources/item_type_resource.dart';
part 'src/resources/preset_resource.dart';
part 'src/responses/data_response.dart';
part 'src/responses/id_response.dart';

const String API_COLLECTIONS_PATH = "collections";
const String API_FIELDS_PATH = "fields";
const String API_IMPORT_PATH = "import";
const String API_ITEM_TYPES_PATH = "item_types";
const String API_HISTORY_PATH = "history";
const String API_COPIES_PATH = "copies";
const String API_ITEMS_PATH = "items";
