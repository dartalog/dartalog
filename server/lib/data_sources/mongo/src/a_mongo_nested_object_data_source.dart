import 'package:option/option.dart';
import 'a_mongo_data_source.dart';
import 'a_mongo_object_data_source.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'constants.dart';
import 'package:dartalog/data/data.dart';
import 'a_mongo_uuid_based_data_source.dart';
import 'package:dartalog_shared/global.dart';

abstract class AMongoNestedObjectDataSource<T extends AParentedUuidData,
    P extends AUuidData> extends AMongoDataSource {

  AMongoNestedObjectDataSource(MongoDbConnectionPool pool): super(pool);

  AMongoUuidBasedDataSource<P> get parentSource;

  String get childFieldPath;
  String get childUuidPath;

  Future<Null> iterateParentObjects(
      SelectorBuilder selector, Future<Null> toAwait(P item),
      {bool errorWhenNotFound: false}) async {
    final Stream<P> items = await parentSource.streamFromDb(selector);
    bool found = false;
    await items.forEach((P item) async {
      found = true;
      await toAwait(item);
    });
    if (!found && errorWhenNotFound) {
      throw new NotFoundException("Parent object not found");
    }
  }

  Future<String> create(String uuid, T o) async {
    o.uuid = uuid;
    final Map data = {};
    updateMap(o, data);
    await genericUpdate(
        where.eq(uuidField, o.parentUuid), modify.push(childFieldPath, data));
    return uuid;
  }

  Future<String> update(String uuid, T o) async {
    o.uuid = uuid;
    final Map data = {};
    updateMap(o, data);

    ModifierBuilder modifier = modify;
    for (String key in data.keys) {
      modifier = modifier.set("$childFieldPath.\$.$key", data[key]);
    }

    await genericUpdate(where.eq(childUuidPath, uuid), modifier);

    return uuid;
  }

  void updateMap(T itemCopy, Map data);
  T createObject(Map data);

  Future<Null> getParentObjectByUuid(String uuid, Future<Null> toAwait(P item),
      {bool errorWhenNotFound: false}) async {
    await iterateParentObjects(where.eq(uuidField, uuid).limit(1), toAwait,
        errorWhenNotFound: errorWhenNotFound);
  }
}
