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
  static const String curatorsField = "curators";
  static const String browsersField = "browsers";

  Future<IdNameList<Collection>> getAllForCurator(String userId)  async {
    SelectorBuilder selector = where.eq(curatorsField, userId);
    return  await getIdNameListFromDb(selector);
  }

  Future<IdNameList<Collection>> getVisibleCollections(String userId) async {
    SelectorBuilder selector = where.eq(publiclyBrowsableField, true)
        .or(where.eq(curatorsField, userId))
        .or(where.eq(browsersField, userId));
    return await getIdNameListFromDb(selector);
  }


  @override
  Collection createObject(Map data) {
    Collection output = new Collection();
    output.id = data[ID_FIELD];
    output.name= data[NAME_FIELD];
    if(data.containsKey(publiclyBrowsableField))
      output.publiclyBrowsable = data[publiclyBrowsableField];
    if(data.containsKey(curatorsField))
      output.curators = data[curatorsField];
    if(data.containsKey(browsersField))
      output.browsers = data[browsersField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getCollectionsCollection();

  @override
  void updateMap(Collection collection, Map data) {
    data[ID_FIELD] = collection.id;
    data[NAME_FIELD] = collection.name;
    data[publiclyBrowsableField] = collection.publiclyBrowsable;
    data[curatorsField] = collection.curators;
    data[browsersField] = collection.browsers;
  }
}
