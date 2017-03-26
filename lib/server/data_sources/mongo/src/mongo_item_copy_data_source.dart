import 'dart:async';
import 'dart:math';
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
import 'a_mongo_uuid_based_data_source.dart';
import 'constants.dart';
import 'a_mongo_nested_object_data_source.dart';

class MongoItemCopyDataSource
    extends AMongoNestedObjectDataSource<ItemCopy, Item>
    with AItemCopyDataSource
{

  static final Logger _log = new Logger('MongoItemCopyDataSource');

  static const String statusField = "status";

  @override
  AMongoUuidBasedDataSource<Item> get parentSource => data_sources.items as AMongoUuidBasedDataSource<Item>;

  Future<Null> iterateItemCopies(SelectorBuilder selector, Future<Null> toAwait(List<ItemCopy> copies), {bool update: false}) async {
    await iterateParentObjects(selector, (Item item) async {
      if(item.copies==null)
        return;
      await toAwait(item.copies);
    }, update: update);
  }


  @override
  Future<Null> deleteByCollection(String collectionUuid) async {
    final SelectorBuilder selector = where
        .eq(itemCopyCollectionPath, collectionUuid);
    await iterateItemCopies(selector, (List<ItemCopy> copies) async {
      for(int i = 0; i < copies.length; i++) {
        final ItemCopy copy = copies[i];
        if(copy.collectionUuid==collectionUuid) {
          copies.removeAt(i);
          i--;
        }
      }
    }, update: true);
  }


  @override
  Future<bool> existsByUniqueId(String uniqueId) =>
      this.exists(where.eq(itemCopyUniqueIdPath, uniqueId));

  @override
  Future<List<ItemCopy>> getAll(List<String> itemCopyUuids) async {
    final List<ItemCopy> output = <ItemCopy>[];

    final SelectorBuilder selector = where.oneFrom(itemCopyUuidPath, itemCopyUuids);
    await iterateParentObjects(selector, (Item item) async {
      for (ItemCopy copy in item.copies) {
        if(itemCopyUuids.contains(copy.uuid))  {
          output.add(copy);
        }
        break;
      }
    });
    if(itemCopyUuids.length!=output.length) {
      // TODO: Report exactly which copies weren't found
      throw new NotFoundException("${(itemCopyUuids.length-output.length).abs()} item copies not found");
    }
    return output;
  }

  @override
  Future<List<ItemCopy>> getAllForItem(String itemUuid,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    final Option<Item> item = await parentSource.getByUuid(itemUuid);
    if(item.isEmpty)
      return [];
    return item.first.copies;
  }

  @override
  Future<List<ItemCopy>> getVisibleForItem(String itemUuid, String userUuid,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    final Option<Item> item = await parentSource.getByUuid(itemUuid);
    if(item.isEmpty)
      return [];

    if (item.first.copies.length == 0) return <ItemCopy>[];
    final UuidDataList<Collection> visibleCollections =
        await data_sources.itemCollections.getVisibleCollections(userUuid);

    item.first.copies.retainWhere((ItemCopy ic) {
      return visibleCollections.containsUuid(ic.collectionUuid);
    });

    return item.first.copies;
  }

  @override
  Future<Option<ItemCopy>> getByUuid(String uuid) async {
    final SelectorBuilder selector = where.eq(itemCopyUuidPath, uuid).limit(1);
    final Option<Item> item = await parentSource.getForOneFromDb(selector);
    if(item.isEmpty)
      return new None<ItemCopy>();

    for (ItemCopy itemCopy in item.first.copies) {
      if (itemCopy.uuid== uuid) {
        return new Some<ItemCopy>(itemCopy);
      }
    }
    return new None<ItemCopy>();
  }

  @override
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId) async {
    final Option<Item> item = await parentSource.getForOneFromDb(where.eq(itemCopyUniqueIdPath, uniqueId).limit(1));
    if(item.isEmpty)
      return new None<ItemCopy>();


    for (ItemCopy copy in item.first.copies) {
      if (copy.uniqueId == uniqueId) {
        return new Some<ItemCopy>(copy);
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
  Future<Null> updateStatus(List<String> itemCopies, String status) async {
    await _updateItemCopies(itemCopies, statusField, status);
  }

  @override
  Future<Null> updateCollection(
      List<String> itemCopies, String collection) async {
    await _updateItemCopies(itemCopies, collectionUuidField, collection);
  }

  Future<Null> _updateItemCopies(
      List<String> itemCopies, String field, dynamic value) async {
    SelectorBuilder selector;
    for (String uuid in itemCopies) {
      if (selector == null) {
        selector = where
            .eq(itemCopyUuidPath, uuid);
      } else {
        selector = selector.or(where
            .eq(itemCopyUuidPath, uuid));
      }
    }
    final ModifierBuilder modifier =
        modify.set( "$itemCopiesField.\$.$field", value);
    await genericUpdate(selector, modifier, multiUpdate: true);
  }

  @override
  Future<String> write(ItemCopy itemCopy, String itemCopyUuid) async {
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
  ItemCopy createObject(Map data) => staticCreateObject(data);

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemsCollection();


  @override
  void updateMap(ItemCopy itemCopy, Map data) {
    data[collectionUuidField] = itemCopy.collectionUuid;
    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId))
      data[uniqueIdField] = itemCopy.uniqueId;
    if (!StringTools.isNullOrWhitespace(itemCopy.status))
      data[statusField] = itemCopy.status;
  }

  static List<ItemCopy> _convertList(List<dynamic> data) {
    final List<ItemCopy> output = new List<ItemCopy>();
    if (data == null) return output;
    for (dynamic item in data) {
      output.add(staticCreateObject(item));
    }
    return output;
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
}
