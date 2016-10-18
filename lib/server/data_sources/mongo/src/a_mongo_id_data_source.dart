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

const String ID_FIELD = "_id";
const String NAME_FIELD = "name";

abstract class AMongoIdDataSource<T extends AIdData>
    extends AMongoObjectDataSource<T> with AIdNameBasedDataSource<T> {
  @override
  Future deleteByID(String id) => deleteFromDb(where.eq(ID_FIELD, id));

  @override
  Future<bool> existsByID(String id) => super.exists(where.eq(ID_FIELD, id));

  Future<IdNameList<T>> getAll({String sortField: ID_FIELD}) =>
      getIdNameListFromDb(where.sortBy(sortField));

  Future<PaginatedIdNameData<T>> getPaginated(
          {String sortField: ID_FIELD,
          int offset: 0,
          int limit: PAGINATED_DATA_LIMIT}) =>
      getPaginatedIdNameListFromDb(where.sortBy(sortField),
          offset: offset, limit: limit);

  Future<IdNameList<IdNamePair>> getAllIdsAndNames(
          {String sortField: ID_FIELD}) =>
      getIdsAndNames(sortField: sortField);

  Future<IdNameList<IdNamePair>> getIdsAndNames(
      {SelectorBuilder selector, String sortField: ID_FIELD}) async {
    return await collectionWrapper((DbCollection collection) async {
      if (selector == null) selector = where;

      selector.sortBy(sortField);

      final List<dynamic> results = await collection.find(selector).toList();

      final IdNameList<IdNamePair> output = new IdNameList<IdNamePair>();

      for (Map<String, dynamic> result in results) {
        output.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
  }

  Future<PaginatedIdNameData<IdNamePair>> getPaginatedIdsAndNames(
      {SelectorBuilder selector,
      String sortField: ID_FIELD,
      int offset: 0,
      int limit: 10}) async {
    return await collectionWrapper((DbCollection collection) async {
      final int count = await collection.count();

      if (selector == null) selector = where;

      final List<dynamic> results = await collection
          .find(selector.sortBy(sortField).limit(limit).skip(offset))
          .toList();

      final PaginatedIdNameData<IdNamePair> output =
          new PaginatedIdNameData<IdNamePair>();
      output.startIndex = offset;
      output.limit = limit;
      output.totalCount = count;

      for (Map<String, dynamic> result in results) {
        output.data.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
  }

  @override
  Future<Option<T>> getById(String id) =>
      getForOneFromDb(where.eq(ID_FIELD, id));

  @override
  Future<String> write(T object, [String id = null]) async {
    if (!StringTools.isNullOrWhitespace(id)) {
      await updateToDb(where.eq(ID_FIELD, id), object);
    } else {
      await insertIntoDb(object);
    }
    return object.getId;
  }

  @protected
  Future<PaginatedIdNameData<T>> getPaginatedIdNameListFromDb(
          SelectorBuilder selector,
          {int offset: 0,
          int limit: PAGINATED_DATA_LIMIT,
          String sortField: ID_FIELD}) async =>
      new PaginatedIdNameData<T>.copyPaginatedData(await getPaginatedFromDb(
          selector,
          offset: offset,
          limit: limit,
          sortField: sortField));

  @override
  Future<PaginatedIdNameData<T>> searchPaginated(String query,
          {SelectorBuilder selector,
          int offset: 0,
          int limit: PAGINATED_DATA_LIMIT}) async =>
      new PaginatedIdNameData.copyPaginatedData(
          await super.searchPaginated(query, offset: offset, limit: limit));

  @protected
  Future<IdNameList<T>> getIdNameListFromDb(dynamic selector) async =>
      new IdNameList<T>.copy(await getFromDb(selector));

  @override
  Future<IdNameList<T>> search(String query,
      {SelectorBuilder selector, String sortBy}) async {
    final List<dynamic> data =
        await super.searchAndSort(query, selector: selector, sortBy: sortBy);
    return new IdNameList.copy(data);
  }
}
