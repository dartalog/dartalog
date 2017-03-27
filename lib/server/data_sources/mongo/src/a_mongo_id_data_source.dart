import 'dart:async';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_object_data_source.dart';
import 'package:meta/meta.dart';

export 'a_mongo_object_data_source.dart';
import 'a_mongo_uuid_based_data_source.dart';
import 'constants.dart';

abstract class AMongoIdDataSource<T extends AHumanFriendlyData>
    extends AMongoUuidBasedDataSource<T> with AIdNameBasedDataSource<T> {
  dynamic prepareId(String id) {
    if (isUuid(id)) {
      //bsonObjectFromTypeByte(3);
      //return new ObjectId.fromHexString(id.replaceAll("\-",""));
      return id;
    } else {
      return id;
    }
  }

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
          int limit: PAGINATED_DATA_LIMIT}) =>
      super.getPaginated(
          sortField: sortField ?? readableIdField,
          offset: offset,
          limit: limit);

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
  Future<Option<T>> getByReadableId(String id) =>
      getForOneFromDb(where.eq(readableIdField, id));

  @override
  void updateMap(T item, Map<String, dynamic> data) {
    super.updateMap(item, data);
    data[nameField] = item.name;
    data[readableIdField] = item.readableId;
  }

  void setIdDataFields(T item, Map<String, dynamic> data) {
    AMongoUuidBasedDataSource.setUuidForData<T>(item, data);
    item.name = data[nameField];
    item.readableId = data[readableIdField];
  }
}
