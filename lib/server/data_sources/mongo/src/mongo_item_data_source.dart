import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_id_data_source.dart';

class MongoItemDataSource extends AMongoIdDataSource<Item>
    with AItemDataSource {
  static final Logger _log = new Logger('MongoItemDataSource');

  Future<Option<SelectorBuilder>> _generateVisibleCriteria(
      String userId) async {
    final IdNameList<Collection> collections =
        await data_sources.itemCollections.getVisibleCollections(userId);
    if (collections.isEmpty) return new None<SelectorBuilder>();

    return new Some<SelectorBuilder>(
        where.oneFrom("copies.collectionId", collections.idList));
  }

  @override
  Future<IdNameList<Item>> getVisible(String userId) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<Item>(),
        (SelectorBuilder selector) async =>
            await getIdNameListFromDb(selector));
  }

  @override
  Future<PaginatedIdNameData<Item>> getVisiblePaginated(String userId,
      {int page: 0, int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new PaginatedIdNameData<Item>(),
        (SelectorBuilder selector) async => await getPaginatedIdNameListFromDb(
            selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  @override
  Future<PaginatedIdNameData<Item>> searchVisiblePaginated(
      String userId, String query,
      {int page: 0, int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new PaginatedIdNameData<Item>(),
        (SelectorBuilder selector) async => await searchPaginated(query,
            selector: selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  @override
  Future<IdNameList<Item>> searchVisible(String userId, String query) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<Item>(),
        (SelectorBuilder selector) async =>
            await search(query, selector: selector));
  }

  @override
  Future<IdNameList<IdNamePair>> getVisibleIdsAndNames(String userId) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<IdNamePair>(),
        (SelectorBuilder selector) async =>
            await getIdsAndNames(selector: selector));
  }

  @override
  Future<PaginatedIdNameData<IdNamePair>> getVisibleIdsAndNamesPaginated(
      String userId,
      {int page: 0,
      int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<IdNamePair>(),
        (SelectorBuilder selector) async => await getPaginatedIdsAndNames(
            selector: selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  @override
  Item createObject(Map<String, dynamic> data) {
    final Item output = new Item();

    output.id = data[ID_FIELD];
    output.name = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];
    output.dateAdded = data["dateAdded"];
    output.dateUpdated = data["dateUpdated"];

    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemsCollection();

  @override
  void updateMap(Item item, Map<String, dynamic> data) {
    data[ID_FIELD] = item.id;
    data["name"] = item.getName;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
    if (item.dateAdded != null) data["dateAdded"] = item.dateAdded;
    data["dateUpdated"] = item.dateUpdated;
  }
}
