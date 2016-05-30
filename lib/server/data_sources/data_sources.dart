library data_sources;

import 'dart:async';
import 'package:logging/logging.dart';

import 'package:connection_pool/connection_pool.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:options_file/options_file.dart';

import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/api/api.dart' as api;


part 'src/exceptions/invalid_input_exception.dart';
part 'src/exceptions/data_moved_exception.dart';
part 'src/exceptions/not_found_exception.dart';
part 'src/exceptions/already_exists_exception.dart';

part 'src/_a_data_source.dart';
part 'src/a_id_name_based_data_source.dart';
part 'src/a_field_model.dart';
part 'src/a_collection_model.dart';
part 'src/a_item_type_model.dart';
part 'src/a_item_copy_model.dart';
part 'src/a_item_copy_history_model.dart';
part 'src/a_item_model.dart';
part 'src/a_user_model.dart';
part 'src/a_settings_model.dart';
part 'src/preset_model.dart';
// part 'src/settings_model.dart';

part 'src/a_database.dart';
part 'src/mongo/_mongo_db_connection_pool.dart';
part 'src/mongo/_mongo_database.dart';
//part 'src/mongo/_mongo_settings_model.dart';
part 'src/mongo/_a_mongo_model.dart';
part 'src/mongo/_a_mongo_id_model.dart';
part 'src/mongo/_mongo_field_model.dart';
part 'src/mongo/_mongo_user_model.dart';
part 'src/mongo/_mongo_item_type_model.dart';
part 'src/mongo/_mongo_item_copy_model.dart';
part 'src/mongo/_mongo_item_copy_history_model.dart';
part 'src/mongo/_mongo_item_model.dart';
part 'src/mongo/_mongo_item_collection_model.dart';

final Logger _log = new Logger('Model');

final AItemModel items = new _MongoItemModel();

final AFieldModel fields = new _MongoFieldModel();

final AItemTypeModel itemTypes = new _MongoItemTypeModel();

final PresetModel presets = new PresetModel();
final AUserModel users= new _MongoUserModel();
final AItemCopyModel itemCopies = new _MongoItemCopyModel();
final AItemCopyHistoryModel itemHistories = new _MongoItemCopyHistoryModel();

final AItemCollectionModel itemCollections = new _MongoItemCollectionModel();

OptionsFile get options {
  return _ADataSource.options;
}
