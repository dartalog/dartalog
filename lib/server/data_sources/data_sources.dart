import 'package:logging/logging.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/mongo/mongo.dart';

final Logger _log = new Logger('Model');

final AItemDataSource items = new MongoItemDataSource();

final AFieldModel fields = new MongoFieldDataSource();

final AItemTypeModel itemTypes = new MongoItemTypeDataSource();

//final PresetModel presets = new PresetModel();
final AUserDataSource users= new MongoUserDataSource();
final AItemCopyDataSource itemCopies = new MongoItemCopyDataSource();
final AItemCopyHistoryModel itemHistories = new MongoItemCopyHistoryDataSource();

final ACollectionDataSource itemCollections = new MongoCollectionDataSource();

