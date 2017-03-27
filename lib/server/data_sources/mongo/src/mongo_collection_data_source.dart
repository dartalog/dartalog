import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';

class MongoCollectionDataSource extends AMongoIdDataSource<Collection>
    with ACollectionDataSource {
  static final Logger _log = new Logger('MongoItemCollectionDataSource');

  static const String publiclyBrowsableField = "publiclyBrowsable";
  static const String curatorUuidsField = "curatorUuids";
  static const String browserUuidsField = "browserUuids";

  @override
  Future<UuidDataList<Collection>> getAllForCurator(String userUuid) async {
    final SelectorBuilder selector = where.eq(curatorUuidsField, userUuid);
    return await getListFromDb(selector);
  }

  @override
  Future<UuidDataList<Collection>> getVisibleCollections(
      String userUuid) async {
    final SelectorBuilder selector = where
        .eq(publiclyBrowsableField, true)
        .or(where.eq(curatorUuidsField, userUuid))
        .or(where.eq(browserUuidsField, userUuid));
    return await getListFromDb(selector);
  }

  @override
  Collection createObject(Map data) {
    final Collection output = new Collection();
    setIdDataFields(output, data);
    if (data.containsKey(publiclyBrowsableField))
      output.publiclyBrowsable = data[publiclyBrowsableField];
    if (data.containsKey(curatorUuidsField))
      output.curatorUuids = data[curatorUuidsField];
    if (data.containsKey(browserUuidsField))
      output.browserUuids = data[browserUuidsField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getCollectionsCollection();

  @override
  void updateMap(Collection collection, Map data) {
    super.updateMap(collection, data);
    data[publiclyBrowsableField] = collection.publiclyBrowsable;
    data[curatorUuidsField] = collection.curatorUuids;
    data[browserUuidsField] = collection.browserUuids;
  }
}
