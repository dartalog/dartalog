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
import 'a_mongo_uuid_based_data_source.dart';
import 'constants.dart';

abstract class AMongoIdDataSource<T extends AHumanFriendlyData>
    extends AMongoUuidBasedDataSource<T> with AIdNameBasedDataSource<T> {

  AMongoIdDataSource(MongoDbConnectionPool pool): super(pool);

  @override
  Future<bool> existsByReadableID(String id) =>
      super.exists(where.eq(readableIdField, id));

  @override
  Future<UuidDataList<T>> getAll({String sortField: null}) =>
      super.getAll(sortField: sortField ?? readableIdField);

  @override
  Future<PaginatedUuidData<T>> getPaginated(
          {String sortField: null,
          int offset: 0,
          int limit: paginatedDataLimit}) =>
      super.getPaginated(
          sortField: sortField ?? readableIdField,
          offset: offset,
          limit: limit);

  @override
  Future<UuidDataList<IdNamePair>> getAllIdsAndNames(
          {String sortField: readableIdField}) =>
      getIdsAndNames(sortField: sortField);

  Future<UuidDataList<IdNamePair>> getIdsAndNames(
      {SelectorBuilder selector, String sortField: readableIdField}) async {
    return await collectionWrapper((DbCollection collection) async {
      SelectorBuilder builder = selector;
      if (selector == null) builder = where;

      builder.sortBy(sortField);

      final List<dynamic> results = await collection.find(builder).toList();

      final UuidDataList<IdNamePair> output = new UuidDataList<IdNamePair>();

      for (Map<String, dynamic> result in results) {
        output.add(new IdNamePair.withValues(
            result[uuidField], result[nameField], result[readableIdField]));
      }

      return output;
    });
  }

  Future<PaginatedUuidData<IdNamePair>> getPaginatedIdsAndNames(
      {SelectorBuilder selector,
      String sortField: uuidField,
      int offset: 0,
      int limit: 10}) async {
    return await collectionWrapper((DbCollection collection) async {
      final int count = await collection.count();

      if (selector == null) selector = where;

      final List<dynamic> results = await collection
          .find(selector.sortBy(sortField).limit(limit).skip(offset))
          .toList();

      final PaginatedUuidData<IdNamePair> output =
          new PaginatedUuidData<IdNamePair>();
      output.startIndex = offset;
      output.limit = limit;
      output.totalCount = count;

      for (Map<String, dynamic> result in results) {
        output.data.add(new IdNamePair.withValues(
            result[uuidField], result[nameField], result[readableIdField]));
      }

      return output;
    });
  }

  @override
  Future<Option<T>> getByReadableId(String readableId) =>
      getForOneFromDb(where.eq(readableIdField, readableId));

  @override
  Future<Option<String>> getUuidForReadableId(String readableId) async {
    final List<dynamic> data = await genericFind(where
        .eq(readableIdField, readableId)
        .limit(1)
        .fields(<String>[uuidField]));
    if (data.isEmpty) return new None<String>();

    return new Some<String>(data.first[uuidField]);
  }

  @override
  void updateMap(AHumanFriendlyData item, Map<String, dynamic> data) {
    staticUpdateMap(item, data);
  }
  static void staticUpdateMap(AHumanFriendlyData item, Map<String, dynamic> data) {
    AMongoUuidBasedDataSource.staticUpdateMap(item, data);
    data[nameField] = item.name;
    data[readableIdField] = item.readableId;
  }


  static void setIdDataFields(AHumanFriendlyData item, Map<String, dynamic> data) {
    AMongoUuidBasedDataSource.setUuidForData(item, data);
    item.name = data[nameField];
    item.readableId = data[readableIdField];
  }
}
