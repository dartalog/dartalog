part of data_sources;

class _MongoItemCopyModel extends _AMongoModel<ItemCopy>
    with AItemCopyModel {
  static final Logger _log = new Logger('_MongoItemCopyModel');

  Future<List<ItemCopy>> getAllForItemId(String itemId) => _getFromDb(mongo.where.eq("itemId", itemId));

  Future<ItemCopy> getByItemIdAndCopy(String itemId, int copy) => _getForOneFromDb(mongo.where.eq("itemId", itemId).eq("copy",copy));

  Future<ItemCopy> getByUniqueId(String uniqueId) => _getForOneFromDb(mongo.where.eq("uniqueId", uniqueId));

  Future delete(String itemId, int copy) => _deleteFromDb(mongo.where.eq("itemId", itemId).eq("copy",copy));

  Future write(ItemCopy itemCopy, [String itemId, int copy]) async {
    if(!tools.isNullOrWhitespace(itemId)||copy!=null) {
      if(tools.isNullOrWhitespace(itemId)||copy==null)
        throw new Exception("Both itemId and copy are required");
      await _updateToDb(mongo.where.eq("itemId", itemId).eq("copy",copy), itemCopy);
    } else {
      await _insertIntoDb(itemCopy);
    }
  }

  ItemCopy _createObject(Map data) {
    ItemCopy output = new ItemCopy();
    output.collectionId = data["collectionId"];
    output.copy = data["copy"];
    output.itemId = data["itemId"];
    output.status = data["status"];

    if(tools.isNullOrWhitespace(data["uniqueId"]))
      output.uniqueId = "";
    else
      output.uniqueId = data["uniqueId"];


    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemCopiesCollection();

  void _updateMap(ItemCopy itemCopy, Map data) {
    data["collectionId"] = itemCopy.collectionId;
    data["copy"] = itemCopy.copy;
    data["itemId"] = itemCopy.itemId;
    if(!tools.isNullOrWhitespace(itemCopy.uniqueId))
      data["uniqueId"] = itemCopy.uniqueId;
    if(!tools.isNullOrWhitespace(itemCopy.status))
      data["status"] = itemCopy.status;

  }

  Future<ItemCopy> getLargestNumberedCopy(String itemId) async {
    dynamic criteria = mongo.where.eq("itemId", itemId).sortBy("copy", descending: true).limit(1);
    ItemCopy output = await _getForOneFromDb(criteria);
    return output;
  }
}
