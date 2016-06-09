library data_sources;

import 'package:logging/logging.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/mongo/mongo.dart';

import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/api/api.dart' as api;
import 'package:dartalog/server/data/data.dart';




final Logger _log = new Logger('Model');

final AItemDataSource items = new MongoItemDataSource();

final AFieldModel fields = new MongoFieldDataSource();

final AItemTypeModel itemTypes = new MongoItemTypeDataSource();

//final PresetModel presets = new PresetModel();
final AUserDataSource users= new MongoUserDataSource();
final AItemCopyDataSource itemCopies = new MongoItemCopyDataSource();
final AItemCopyHistoryModel itemHistories = new MongoItemCopyHistoryDataSource();

final ACollectionDataSource itemCollections = new MongoCollectionDataSource();

