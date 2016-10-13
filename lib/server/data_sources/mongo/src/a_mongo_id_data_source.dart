import 'dart:async';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart' as tools;
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

  Future<PaginatedIdNameData<T>> getPaginated({String sortField: ID_FIELD, int offset: 0, int limit: PAGINATED_DATA_LIMIT}) =>
      getPaginatedIdNameListFromDb(where.sortBy(sortField), offset: offset, limit: limit);

  Future<IdNameList<IdNamePair>> getAllIdsAndNames(
      {String sortField: ID_FIELD}) => getIdsAndNames(sortField: sortField);

  Future<IdNameList<IdNamePair>> getIdsAndNames(
      {SelectorBuilder selector, String sortField: ID_FIELD}) async {
    return await collectionWrapper((DbCollection collection) async {

      if(selector==null)
        selector = where;

      selector.sortBy(sortField);

      List results = await collection.find(selector).toList();

      IdNameList<IdNamePair> output = new IdNameList<IdNamePair>();

      for (var result in results) {
        output.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
  }

  Future<PaginatedIdNameData<IdNamePair>> getPaginatedIdsAndNames(
      {SelectorBuilder selector, String sortField: ID_FIELD, int offset: 0, int limit: 10}) async {
    return await collectionWrapper((DbCollection collection) async {
      int count = await collection.count();

      if(selector==null)
        selector = where;

      List results = await collection.find(selector.sortBy(sortField).limit(limit).skip(offset)).toList();

      PaginatedIdNameData<IdNamePair> output = new PaginatedIdNameData<IdNamePair>();
      output.startIndex = offset;
      output.limit = limit;
      output.totalCount = count;

      for (var result in results) {
        output.data.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
  }

  Future<Option<T>> getById(String id) =>
      getForOneFromDb(where.eq(ID_FIELD, id));

  Future<String> write(T object, [String id = null]) async {
    if (!tools.isNullOrWhitespace(id)) {
      await updateToDb(where.eq(ID_FIELD, id), object);
    } else {
      await insertIntoDb(object);
    }
    dynamic tmp = object;
    return tmp.getId;
  }

  @protected
  Future<PaginatedIdNameData<T>> getPaginatedIdNameListFromDb(SelectorBuilder selector, {int offset: 0, int limit: PAGINATED_DATA_LIMIT, String sortField: ID_FIELD}) async =>
      new PaginatedIdNameData<T>.copyPaginatedData(await getPaginatedFromDb(selector, offset: offset, limit:limit, sortField: sortField));

  @override
  Future<PaginatedIdNameData<T>> searchPaginated(String query,
      {SelectorBuilder selector, int offset: 0, int limit: PAGINATED_DATA_LIMIT}) async =>
      new PaginatedIdNameData.copyPaginatedData(await super.searchPaginated(query, offset: offset, limit:  limit));

  @protected
  Future<IdNameList<T>> getIdNameListFromDb(dynamic selector) async =>
    new IdNameList<T>.copy(await getFromDb(selector));

  @override
  Future<IdNameList<T>> search(String query, {SelectorBuilder selector, String sortBy}) async {
    List data = await super.searchAndSort(query, selector: selector, sortBy: sortBy);
    return new IdNameList.copy(data);
  }

}
