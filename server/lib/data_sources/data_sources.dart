import 'package:di/di.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/data_sources/mongo/mongo.dart';
import 'package:dartalog_shared/tools.dart';

export 'interfaces/interfaces.dart';
final Logger _log = new Logger('Model');

ModuleInjector createDataSourceModuleInjector(String connectionString) {
  final Module module = new Module()
    ..bind(AItemDataSource, toImplementation: MongoItemDataSource)
    ..bind(AFieldDataSource, toImplementation: MongoFieldDataSource)
    ..bind(AItemTypeDataSource, toImplementation: MongoItemTypeDataSource)
  //..bind(PresetModel, toImplementation: PresetModel)
    ..bind(AUserDataSource, toImplementation: MongoUserDataSource)
    ..bind(AItemCopyDataSource, toImplementation: MongoItemCopyDataSource)
    ..bind(AHistoryDataSource, toImplementation: MongoHistoryDataSource)
    ..bind(ACollectionDataSource, toImplementation: MongoCollectionDataSource)
  ..bind(MongoDbConnectionPool, toFactory: () => new MongoDbConnectionPool(connectionString));

  return new ModuleInjector(<Module>[module]);

}
