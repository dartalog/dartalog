library data_sources.mongo;

import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:option/option.dart';

part 'src/_mongo_db_connection_pool.dart';
part 'src/_mongo_database.dart';
//part 'src/mongo/_mongo_settings_model.dart';
part 'src/_a_mongo_data_source.dart';
part 'src/_a_mongo_id_data_source.dart';
part 'src/mongo_field_data_source.dart';
part 'src/mongo_user_data_source.dart';
part 'src/mongo_item_type_data_source.dart';
part 'src/mongo_item_copy_data_source.dart';
part 'src/mongo_item_copy_history_data_source.dart';
part 'src/mongo_item_data_source.dart';
part 'src/mongo_collection_data_source.dart';

const String ID_FIELD = "_id";

const String _TEXT_COMMAND = "\$text";
const String _UNWIND_COMMAND = "\$unwind";
const String _MATCH_COMMAND = "\$match";
const String _PROJECT_COMMAND = "\$project";
const String _SEARCH_COMMAND = "\$search";
