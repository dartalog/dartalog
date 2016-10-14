import 'dart:async';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/server/data/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'package:meta/meta.dart';
import 'a_mongo_data_source.dart';
import 'constants.dart';

export 'a_mongo_data_source.dart';

abstract class AMongoObjectDataSource<T> extends AMongoDataSource {
  @protected
  Future<List<T>> searchAndSort(String query,
      {SelectorBuilder selector, String sortBy}) async {
    SelectorBuilder searchSelector =_prepareTextSearch(query, selector: selector);
    return await getFromDb(searchSelector);
  }


  Future<PaginatedData<T>> searchPaginated(String query,
      {SelectorBuilder selector, int offset: 0, int limit: PAGINATED_DATA_LIMIT}) async {

    SelectorBuilder searchSelector =_prepareTextSearch(query, selector: selector);
    return await getPaginatedFromDb(searchSelector);
  }

  Map _createMap(T object) {
    Map data = new Map();
    updateMap(object, data);
    return data;
  }

  @protected
  T createObject(Map data);

  @protected
  Future<DbCollection> getCollection(MongoDatabase con);

  @protected
  Future<Option<T>> getForOneFromDb(SelectorBuilder selector) async {
    selector = selector.limit(1);
    List results = await getFromDb(selector);
    if (results.length == 0) {
      return new None();
    }
    return new Some(results.first);
  }

  @protected
  Future<List<T>> getFromDb(dynamic selector) async {
    List results = await genericFind(selector);
    List<T> output = new List<T>();
    for (var result in results) {
      output.add(createObject(result));
    }
    return output;
  }

  @protected
  Future<PaginatedData<T>> getPaginatedFromDb(SelectorBuilder selector,
      {int offset: 0, int limit: PAGINATED_DATA_LIMIT, String sortField}) async {
    PaginatedData<T> output = new PaginatedData<T>();
    output.totalCount = await genericCount(selector);
    output.limit = limit;
    output.startIndex = offset;

    if (selector == null) selector == where;
    if(!tools.isNullOrWhitespace(sortField))
      selector.sortBy(sortField);

    selector.limit(limit).skip(offset);



    output.data.addAll(await getFromDb(selector));
    return output;
  }

  @protected
  Future insertIntoDb(T item) async {
    return await collectionWrapper((DbCollection collection) async {
      Map data = _createMap(item);
      await collection.insert(data);
    });
  }

  SelectorBuilder _prepareTextSearch(String query, {SelectorBuilder selector, String sortBy}) {
    SelectorBuilder searchSelector =
      where.eq(TEXT_COMMAND, {SEARCH_COMMAND: query});
    if (selector != null) searchSelector = searchSelector.and(selector);
    if (!tools.isNullOrWhitespace(sortBy)) {
      searchSelector = searchSelector.sortBy(sortBy);
    } else {
      searchSelector = searchSelector.metaTextScore("score").sortByMetaTextScore("score");
    }
    return searchSelector;

  }


  @protected
  updateMap(T object, Map data);

  @protected
  Future updateToDb(dynamic selector, T item) async {
    return await collectionWrapper((DbCollection collection) async {
      Map data = await collection.findOne(selector);
      if (data == null)
        throw new InvalidInputException("Object to update not found");
      dynamic originalId = data['_id'];
      updateMap(item, data);
      await collection.save(data);
      if(data['_id']!=originalId)
        await collection.remove(selector);
    });
  }
}
