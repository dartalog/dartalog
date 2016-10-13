import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';

class MongoCollectionDataSource extends AMongoIdDataSource<Collection>
    with ACollectionDataSource {
  static final Logger _log = new Logger('MongoItemCollectionDataSource');

  static const String PUBLICLY_BROWSABLE_FIELD = "publiclyBrowsable";
  static const String CURATORS_FIELD = "curators";
  static const String BROWSERS_FIELD = "browsers";

  Future<IdNameList<Collection>> getAllForCurator(String userId)  async {
    SelectorBuilder selector = where.eq(CURATORS_FIELD, userId);
    return  await getIdNameListFromDb(selector);
  }

  Future<IdNameList<Collection>> getVisibleCollections(String userId) async {
    SelectorBuilder selector = where.eq(PUBLICLY_BROWSABLE_FIELD, true)
        .or(where.eq(CURATORS_FIELD, userId))
        .or(where.eq(BROWSERS_FIELD, userId));
    return await getIdNameListFromDb(selector);
  }


  @override
  Collection createObject(Map data) {
    Collection output = new Collection();
    output.id = data[ID_FIELD];
    output.name= data[NAME_FIELD];
    if(data.containsKey(PUBLICLY_BROWSABLE_FIELD))
      output.publiclyBrowsable = data[PUBLICLY_BROWSABLE_FIELD];
    if(data.containsKey(CURATORS_FIELD))
      output.curators = data[CURATORS_FIELD];
    if(data.containsKey(BROWSERS_FIELD))
      output.browsers = data[BROWSERS_FIELD];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getCollectionsCollection();

  @override
  void updateMap(Collection collection, Map data) {
    data[ID_FIELD] = collection.id;
    data[NAME_FIELD] = collection.name;
    data[PUBLICLY_BROWSABLE_FIELD] = collection.publiclyBrowsable;
    data[CURATORS_FIELD] = collection.curators;
    data[BROWSERS_FIELD] = collection.browsers;
  }
}
