library data_sources;

import 'dart:async';
import 'package:logging/logging.dart';

import 'package:connection_pool/connection_pool.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/api/api.dart' as api;
import 'package:dartalog/server/data/data.dart';

part 'src/exceptions/data_moved_exception.dart';
part 'src/exceptions/already_exists_exception.dart';

part 'src/_a_data_source.dart';
part 'src/a_id_name_based_data_source.dart';
part 'src/a_field_model.dart';
part 'src/a_collection_model.dart';
part 'src/a_item_type_model.dart';
part 'src/a_item_copy_data_source.dart';
part 'src/a_item_copy_history_model.dart';
part 'src/a_item_data_source.dart';
part 'src/a_user_data_source.dart';
part 'src/a_settings_model.dart';
part 'src/preset_model.dart';
// part 'src/settings_model.dart';

part 'src/a_database.dart';
part 'src/mongo/_mongo_db_connection_pool.dart';
part 'src/mongo/_mongo_database.dart';
//part 'src/mongo/_mongo_settings_model.dart';
part 'src/mongo/_a_mongo_data_source.dart';
part 'src/mongo/_a_mongo_id_data_sourcel.dart';
part 'src/mongo/_mongo_field_model.dart';
part 'src/mongo/_mongo_user_data_source.dart';
part 'src/mongo/_mongo_item_type_model.dart';
part 'src/mongo/_mongo_item_copy_data_source.dart';
part 'src/mongo/_mongo_item_copy_history_model.dart';
part 'src/mongo/_mongo_item_data_source.dart';
part 'src/mongo/_mongo_item_collection_model.dart';

final Logger _log = new Logger('Model');

final AItemDataSource items = new _MongoItemDataSource();

final AFieldModel fields = new _MongoFieldModel();

final AItemTypeModel itemTypes = new _MongoItemTypeModel();

final PresetModel presets = new PresetModel();
final AUserDataSource users= new _MongoUserDataSource();
final AItemCopyDataSource itemCopies = new _MongoItemCopyDataSource();
final AItemCopyHistoryModel itemHistories = new _MongoItemCopyHistoryModel();

final AItemCollectionModel itemCollections = new _MongoItemCollectionModel();

