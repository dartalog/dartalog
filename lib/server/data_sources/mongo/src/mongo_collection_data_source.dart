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

  @override
  Future<IdNameList<Collection>> getAllForCurator(String userId) async {
    final SelectorBuilder selector = where.eq(curatorsField, userId);
    return await getIdNameListFromDb(selector);
  }

  @override
  Future<IdNameList<Collection>> getVisibleCollections(String userId) async {
    final SelectorBuilder selector = where
        .eq(publiclyBrowsableField, true)
        .or(where.eq(curatorsField, userId))
        .or(where.eq(browsersField, userId));
    return await getIdNameListFromDb(selector);
  }

  @override
  Collection createObject(Map data) {
    final Collection output = new Collection();
    setIdDataFields(output, data);
    if (data.containsKey(publiclyBrowsableField))
      output.publiclyBrowsable = data[publiclyBrowsableField];
    if (data.containsKey(curatorsField)) output.curators = data[curatorsField];
    if (data.containsKey(browsersField)) output.browsers = data[browsersField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getCollectionsCollection();

  @override
  void updateMap(Collection collection, Map data) {
    super.updateMap(collection, data);
    data[publiclyBrowsableField] = collection.publiclyBrowsable;
    data[curatorsField] = collection.curators;
    data[browsersField] = collection.browsers;
  }
}
