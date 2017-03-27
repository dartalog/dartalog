import 'dart:async';
import 'dart:math';

import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';

import 'a_mongo_id_data_source.dart';
import 'a_mongo_nested_object_data_source.dart';
import 'a_mongo_object_data_source.dart';
import 'a_mongo_uuid_based_data_source.dart';
import 'constants.dart';
import 'mongo_item_data_source.dart';

class MongoItemCopyDataSource
    extends AMongoNestedObjectDataSource<ItemCopy, Item>
    with AItemCopyDataSource {
  static final Logger _log = new Logger('MongoItemCopyDataSource');

  static const String statusField = "status";

  @override
  String get childFieldPath=> itemCopiesField;
  @override
  String get childUuidPath => itemCopyUuidPath;
  @override
  AMongoUuidBasedDataSource<Item> get parentSource =>
      data_sources.items as AMongoUuidBasedDataSource<Item>;
  @override
  ItemCopy createObject(Map data) => staticCreateObject(data);

  @override
  Future<Null> deleteByCollection(String collectionUuid) async {
    final SelectorBuilder selector =
        where.eq(itemCopyCollectionPath, collectionUuid);
    //    { $pull: { fruits: { $in: [ "apples", "oranges" ] }, vegetables: "carrots" } },

    final ModifierBuilder modifier = modify.pull(itemCopiesField, where.eq(collectionUuidField, collectionUuid));

    await parentSource.genericUpdate(selector, modifier, multiUpdate: true);
    // TODO: Delete item history as well, eh?
  }

  @override
  Future<Null> deleteByUuid(String uuid) => throw new NotImplementedException();

  @override
  Future<bool> existsByUniqueId(String uniqueId) =>
      this.exists(where.eq(itemCopyUniqueIdPath, uniqueId));

  @override
  Future<bool> existsByUuid(String uuid) => throw new NotImplementedException();

  @override
  Future<UuidDataList<ItemCopy>> getAll() =>
      throw new NotImplementedException();

  @override
  Future<List<ItemCopy>> getAllByUuids(List<String> itemCopyUuids) async {
    final List<ItemCopy> output = <ItemCopy>[];

    final SelectorBuilder selector =
        where.oneFrom(itemCopyUuidPath, itemCopyUuids);
    await iterateParentObjects(selector, (Item item) async {
      for (ItemCopy copy in item.copies) {
        if (itemCopyUuids.contains(copy.uuid)) {
          output.add(copy);
        }
        break;
      }
    });
    if (itemCopyUuids.length != output.length) {
      // TODO: Report exactly which copies weren't found
      throw new NotFoundException(
          "${(itemCopyUuids.length-output.length).abs()} item copies not found");
    }
    return output;
  }

  @override
  Future<List<ItemCopy>> getByItemUuid(String itemUuid,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    final Option<Item> item = await parentSource.getByUuid(itemUuid);
    if (item.isEmpty) return [];
    return item.first.copies;
  }

  @override
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId) async {
    final Option<Item> item = await parentSource
        .getForOneFromDb(where.eq(itemCopyUniqueIdPath, uniqueId).limit(1));
    if (item.isEmpty) return new None<ItemCopy>();

    for (ItemCopy copy in item.first.copies) {
      if (copy.uniqueId == uniqueId) {
        return new Some<ItemCopy>(copy);
      }
    }
    return new None<ItemCopy>();
  }

  @override
  Future<Option<ItemCopy>> getByUuid(String uuid) async {
    final Option<Item> item = await _getItemByItemCopyUuid(uuid);
    if (item.isEmpty) return new None<ItemCopy>();

    for (ItemCopy itemCopy in item.first.copies) {
      if (itemCopy.uuid == uuid) {
        return new Some<ItemCopy>(itemCopy);
      }
    }
    return new None<ItemCopy>();
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemsCollection();

  @override
  Future<List<ItemCopy>> getVisibleForItem(String itemUuid, String userUuid,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    final Option<Item> item = await parentSource.getByUuid(itemUuid);
    if (item.isEmpty) return [];

    if (item.first.copies.length == 0) return <ItemCopy>[];
    final UuidDataList<Collection> visibleCollections =
        await data_sources.itemCollections.getVisibleCollections(userUuid);

    item.first.copies.retainWhere((ItemCopy ic) {
      return visibleCollections.containsUuid(ic.collectionUuid);
    });

    return item.first.copies;
  }



  @override
  Future<UuidDataList<ItemCopy>> search(String query) =>
      throw new NotImplementedException();

  @override
  Future<Null> updateCollection(
      List<String> itemCopies, String collection) async {
    await _updateItemCopies(itemCopies, collectionUuidField, collection);
  }
  @override
  void updateMap(ItemCopy itemCopy, Map data) {
    data[collectionUuidField] = itemCopy.collectionUuid;
    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId))
      data[uniqueIdField] = itemCopy.uniqueId;
    if (!StringTools.isNullOrWhitespace(itemCopy.status))
      data[statusField] = itemCopy.status;
  }

  @override
  Future<Null> updateStatus(List<String> itemCopies, String status) async {
    await _updateItemCopies(itemCopies, statusField, status);
  }

  Future<Option<Item>> _getItemByItemCopyUuid(String uuid) async {
    final SelectorBuilder selector = where.eq(itemCopyUuidPath, uuid).limit(1);
    return await parentSource.getForOneFromDb(selector);
  }

  Future<Null> _updateItemCopies(
      List<String> itemCopies, String field, dynamic value) async {
    await genericUpdate(where.oneFrom(itemCopyUuidPath, itemCopies),
        modify.set("$itemCopiesField.\$.$field", value),
        multiUpdate: true);
  }

  static ItemCopy staticCreateObject(Map data) {
    final ItemCopy output = new ItemCopy();
    AMongoUuidBasedDataSource.setUuidForData(output, data);
    output.collectionUuid = data[collectionUuidField];
    output.status = data[statusField];

    if (StringTools.isNullOrWhitespace(data[uniqueIdField]))
      output.uniqueId = "";
    else
      output.uniqueId = data[uniqueIdField];

    return output;
  }

  static List<ItemCopy> _convertList(List<dynamic> data) {
    final List<ItemCopy> output = new List<ItemCopy>();
    if (data == null) return output;
    for (dynamic item in data) {
      output.add(staticCreateObject(item));
    }
    return output;
  }
}
