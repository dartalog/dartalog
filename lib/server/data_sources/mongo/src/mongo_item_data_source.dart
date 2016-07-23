part of data_sources.mongo;

class MongoItemDataSource extends _AMongoIdDataSource<Item>
    with AItemDataSource {
  static final Logger _log = new Logger('MongoItemDataSource');

  Future<Option<SelectorBuilder>> _generateVisibleCriteria(String userId) async {
    IdNameList collections =
    await data_sources.itemCollections.getVisibleCollections(userId);
    if (collections.isEmpty) return new None();

    return new Some(
    where.oneFrom("copies.collectionId", collections.idList));
  }

  Future<IdNameList<Item>> getVisible(String userId) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<Item>(),
        (SelectorBuilder selector) async =>
    await _getIdNameListFromDb(selector));
  }

  Future<PaginatedIdNameData<Item>> getVisiblePaginated(String userId, {int page: 0, int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new PaginatedIdNameData<Item>(),
        (SelectorBuilder selector) async =>
    await _getPaginatedIdNameListFromDb(selector,
        limit: perPage, offset: getOffset(page, perPage)));
  }

  Future<PaginatedIdNameData<Item>> searchVisiblePaginated(String userId, String query, {int page: 0, int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new PaginatedIdNameData<Item>(),
        (SelectorBuilder selector) async => await searchPaginated(query,selector: selector, limit: perPage, offset: getOffset(page, perPage)));
  }


  Future<IdNameList<Item>> searchVisible(String userId, String query) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<Item>(),
        (SelectorBuilder selector) async => await search(query,selector: selector));
  }

  Future<IdNameList<IdNamePair>> getVisibleIdsAndNames(String userId) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<IdNamePair>(),
        (SelectorBuilder selector) async => await getIdsAndNames(selector: selector));
  }

  Future<PaginatedIdNameData<IdNamePair>> getVisibleIdsAndNamesPaginated(String userId, {int page: 0, int perPage: DEFAULT_PER_PAGE}) async {
    return (await _generateVisibleCriteria(userId)).cata(
        () => new IdNameList<IdNamePair>(),
        (SelectorBuilder selector) async => await getPaginatedIdsAndNames(selector: selector, limit: perPage, offset: getOffset(page, perPage)));
  }

  Item _createObject(Map data) {
    Item output = new Item();

    output.id = data[ID_FIELD];
    output.getName = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];
    output.dateAdded = data["dateAdded"];
    output.dateUpdated = data["dateUpdated"];

    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();

  void _updateMap(Item item, Map data) {
    data[ID_FIELD] = item.id;
    data["name"] = item.getName;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
    if (item.dateAdded != null) data["dateAdded"] = item.dateAdded;
    data["dateUpdated"] = item.dateUpdated;
  }
}
