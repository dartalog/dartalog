import 'dart:async';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_object_data_source.dart';
import 'package:meta/meta.dart';

export 'a_mongo_object_data_source.dart';
import 'constants.dart';

abstract class AMongoUuidBasedDataSource<T extends AUuidData>
    extends AMongoObjectDataSource<T> with AUuidBasedDataSource<T> {

  AMongoUuidBasedDataSource(MongoDbConnectionPool pool): super(pool);



  dynamic convertUuid(String uuid) {
    if (isUuid(uuid)) {
      //bsonObjectFromTypeByte(3);
      //return new ObjectId.fromHexString(id.replaceAll("\-",""));
      // TODO: Convert the uuid to a native data format, currently not properly supported in the mongo dart lib
      return uuid;
    } else {
      return uuid;
    }
  }

  @override
  Future<Null> deleteByUuid(String uuid) =>
      deleteFromDb(where.eq(uuidField, convertUuid(uuid)));

  @override
  Future<bool> existsByUuid(String uuid) =>
      super.exists(where.eq(uuidField, convertUuid(uuid)));

  @override
  Future<UuidDataList<T>> getAll({String sortField: null}) =>
      getListFromDb(where.sortBy(sortField ?? uuidField));

  Future<PaginatedUuidData<T>> getPaginated(
          {String sortField: null,
          int offset: 0,
          int limit: paginatedDataLimit}) =>
      getPaginatedListFromDb(where.sortBy(sortField ?? uuidField),
          offset: offset, limit: limit);

  @override
  Future<Option<T>> getByUuid(String uuid) =>
      getForOneFromDb(where.eq(uuidField, convertUuid(uuid)));

  @override
  Future<String> create(String uuid, T object) async {
    object.uuid = uuid;
    await insertIntoDb(object);
    return object.uuid;
  }

  @override
  Future<String> update(String uuid, T object) async {
    object.uuid = uuid;
    await updateToDb(where.eq(uuidField, convertUuid(uuid)), object);
    return object.uuid;
  }

  @override
  void updateMap(AUuidData item, Map<String, dynamic> data) {
    staticUpdateMap(item, data);
  }
  static void staticUpdateMap(AUuidData item, Map<String, dynamic> data) {
    data[uuidField] = item.uuid;
  }

  static void setUuidForData(
      AUuidData item, Map<String, dynamic> data) {
    item.uuid = data[uuidField];
  }

  @protected
  Future<PaginatedUuidData<T>> getPaginatedListFromDb(SelectorBuilder selector,
          {int offset: 0,
          int limit: paginatedDataLimit,
          String sortField: uuidField}) async =>
      new PaginatedUuidData<T>.copyPaginatedData(await getPaginatedFromDb(
          selector,
          offset: offset,
          limit: limit,
          sortField: sortField));

  @override
  Future<PaginatedUuidData<T>> searchPaginated(String query,
          {SelectorBuilder selector,
          int offset: 0,
          int limit: paginatedDataLimit}) async =>
      new PaginatedUuidData<T>.copyPaginatedData(
          await super.searchPaginated(query, offset: offset, limit: limit));

  @protected
  Future<UuidDataList<T>> getListFromDb(dynamic selector) async =>
      new UuidDataList<T>.copy(await getFromDb(selector));

  @override
  Future<UuidDataList<T>> search(String query,
      {SelectorBuilder selector, String sortBy}) async {
    final List<dynamic> data =
        await super.searchAndSort(query, selector: selector, sortBy: sortBy);
    return new UuidDataList<T>.copy(data);
  }
}
