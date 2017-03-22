import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_object_data_source.dart';
import 'a_mongo_id_data_source.dart';
import 'mongo_item_data_source.dart';

class MongoItemCopyDataSource extends AMongoObjectDataSource<ItemCopy>
    with AItemCopyDataSource {
  static final Logger _log = new Logger('MongoItemCopyDataSource');

  static const String _ITEM_COPIES_FIELD = "copies";

  static const String _COLLECTION_ID_FIELD = "collectionId";
  static const String _COPY_FIELD = "copy";
  static const String _STATUS_FIELD = "status";
  static const String _UNIQUE_ID_FIELD = "uniqueId";

  static const String _ITEM_COPIES_COPY_FIELD_PATH =
      "${_ITEM_COPIES_FIELD}.${_COPY_FIELD}";

  static const String _itemCopiesCollectionIdPath =
      "${_ITEM_COPIES_FIELD}.${_COLLECTION_ID_FIELD}";

  @override
  Future<Null> delete(String itemId, int copy) => genericUpdate(
      where.eq(idField, itemId),
      modify.pull(_ITEM_COPIES_FIELD, {_COPY_FIELD: copy}));

  @override
  Future<bool> existsByItemIdAndCopy(String itemId, int copy) async {
    final List<ItemCopy> copies =
        await getAllForItemId(itemId, includeRemoved: true);
    for (ItemCopy itemCopy in copies) {
      if (itemCopy.copy == copy) return true;
    }
    return false;
  }

  @override
  Future<Null> deleteByCollection(String collectionId) async {
    final SelectorBuilder selector = where
        .eq(_itemCopiesCollectionIdPath, collectionId);

    final MongoItemDataSource itemsSource = data_sources.items;
    final Stream<Map<dynamic,dynamic>> items = await itemsSource.genericFindStream(selector);
    await items.forEach((Map<dynamic,dynamic> item) {
      final List<dynamic> copies = item[_ITEM_COPIES_FIELD];
      if(copies==null)
        return;

      for(int i = 0; i < copies.length; i++) {
        final Map<dynamic,dynamic> copy = copies[i];
        if(copy[_COLLECTION_ID_FIELD]==collectionId) {
          copies.removeAt(i);
          i--;
        }
      }
      final SelectorBuilder selector = where
          .eq(idField, item[idField]);
      itemsSource.genericUpdate(selector, item, multiUpdate: false);
    });
  }


  @override
  Future<bool> existsByUniqueId(String uniqueId) =>
      this.exists(where.eq("$_ITEM_COPIES_FIELD.$_UNIQUE_ID_FIELD", uniqueId));

  @override
  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies) async {
    final List<ItemCopy> output = <ItemCopy>[];
    for (ItemCopyId id in itemCopies) {
      final List<ItemCopy> copies = await getAllForItemId(id.itemId);

      ItemCopy candidate;
      for (ItemCopy ic in copies) {
        if (ic.copy == id.copy) candidate = ic;
        break;
      }

      if (candidate == null) throw new NotFoundException("Item copy not found");

      candidate.itemId = id.itemId;
      output.add(candidate);
    }
    return output;
  }

  @override
  Future<List<ItemCopy>> getAllForItemId(String itemId,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    return _convertList((await _getItemData(itemId))[_ITEM_COPIES_FIELD]);
  }

  @override
  Future<List<ItemCopy>> getVisibleForItemId(String itemId, String userName,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    final List<ItemCopy> output =
        _convertList((await _getItemData(itemId))[_ITEM_COPIES_FIELD]);
    if (output.length == 0) return <ItemCopy>[];
    final IdNameList<Collection> visibleCollections =
        await data_sources.itemCollections.getVisibleCollections(userName);
    output.retainWhere((ItemCopy ic) {
      return visibleCollections.containsId(ic.collectionId);
    });
    return output;
  }

  @override
  Future<Option<ItemCopy>> getByItemIdAndCopy(String itemId, int copy) async {
    final List<ItemCopy> copies =
        await getAllForItemId(itemId, includeRemoved: true);
    for (ItemCopy itemCopy in copies) {
      itemCopy.itemId = itemId;
      if (itemCopy.copy == copy) return new Some<ItemCopy>(itemCopy);
    }
    return new None<ItemCopy>();
  }

  @override
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId) async {
    final List<dynamic> results = await genericFind(
        where.eq("$_ITEM_COPIES_FIELD.$_UNIQUE_ID_FIELD", uniqueId).limit(1));

    if (results.length > 0) {
      final Map<String, dynamic> data = results[0];
      for (Map<String, dynamic> copy in data[_ITEM_COPIES_FIELD]) {
        if (copy[_UNIQUE_ID_FIELD] == uniqueId) {
          final ItemCopy output = createObject(copy);
          output.itemId = data[idField];
          return new Some<ItemCopy>(output);
        }
      }
    }
    return new None<ItemCopy>();
  }

  @override
  Future<int> getNextCopyNumber(String itemId) async {
    // TODO: Convert this to use mongo aggregation
    final Map<String, dynamic> data = await _getItemData(itemId);
    int candidate = 0;
    if (data.containsKey(_ITEM_COPIES_FIELD)) {
      for (Map<String, dynamic> copy in data[_ITEM_COPIES_FIELD]) {
        if (copy[_COPY_FIELD] > candidate) candidate = copy[_COPY_FIELD];
      }
    }
    candidate++;
    return candidate;
  }

  @override
  Future<Null> updateStatus(List<ItemCopyId> itemCopies, String status) async {
    await _updateItemCopies(itemCopies, _STATUS_FIELD, status);
  }

  @override
  Future<Null> updateCollection(
      List<ItemCopyId> itemCopies, String collection) async {
    await _updateItemCopies(itemCopies, _COLLECTION_ID_FIELD, collection);
  }

  Future<Null> _updateItemCopies(
      List<ItemCopyId> itemCopies, String field, dynamic value) async {
    SelectorBuilder selector;
    for (ItemCopyId id in itemCopies) {
      if (selector == null) {
        selector = where
            .eq(idField, id.itemId)
            .eq(_ITEM_COPIES_COPY_FIELD_PATH, id.copy);
      } else {
        selector = selector.or(where
            .eq(idField, id.itemId)
            .eq(_ITEM_COPIES_COPY_FIELD_PATH, id.copy));
      }
    }
    final ModifierBuilder modifier =
        modify.set("$_ITEM_COPIES_FIELD.\$.$field", value);
    await genericUpdate(selector, modifier, multiUpdate: true);
  }

  @override
  Future<ItemCopyId> write(ItemCopy itemCopy, bool update) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    updateMap(itemCopy, data);
    dynamic selector;
    dynamic modifier;
    if (update) {
      selector = where
          .eq(idField, itemCopy.itemId)
          .eq(_ITEM_COPIES_COPY_FIELD_PATH, itemCopy.copy);

      modifier = modify;
      for (String key in data.keys) {
        modifier = modifier.set("$_ITEM_COPIES_FIELD.\$.$key", data[key]);
      }
    } else {
      selector = where.eq(idField, itemCopy.itemId);
      modifier = modify.push(_ITEM_COPIES_FIELD, data);
    }

    await genericUpdate(selector, modifier);

    return new ItemCopyId.fromItemCopy(itemCopy);
  }

  @override
  ItemCopy createObject(Map data) => _staticCreateObject(data);

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemsCollection();

  Future<Map<String, dynamic>> _getItemData(String itemId) async {
    final dynamic criteria = where.eq(idField, itemId);
    final List<dynamic> results = await genericFind(criteria);
    if (results.length == 0)
      throw new NotFoundException("Requested item not found");
    return results[0];
  }

  @override
  void updateMap(ItemCopy itemCopy, Map data) {
    data[_COLLECTION_ID_FIELD] = itemCopy.collectionId;
    data[_COPY_FIELD] = itemCopy.copy;
    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId))
      data[_UNIQUE_ID_FIELD] = itemCopy.uniqueId;
    if (!StringTools.isNullOrWhitespace(itemCopy.status))
      data[_STATUS_FIELD] = itemCopy.status;
  }

  static List<ItemCopy> _convertList(List<dynamic> data) {
    final List<ItemCopy> output = new List<ItemCopy>();
    if (data == null) return output;
    for (dynamic item in data) {
      output.add(_staticCreateObject(item));
    }
    return output;
  }

  static ItemCopy _staticCreateObject(Map data) {
    final ItemCopy output = new ItemCopy();
    output.collectionId = data[_COLLECTION_ID_FIELD];
    output.copy = data[_COPY_FIELD];
    output.status = data[_STATUS_FIELD];

    if (StringTools.isNullOrWhitespace(data[_UNIQUE_ID_FIELD]))
      output.uniqueId = "";
    else
      output.uniqueId = data[_UNIQUE_ID_FIELD];

    return output;
  }
}
