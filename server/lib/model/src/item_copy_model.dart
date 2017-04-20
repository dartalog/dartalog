import 'dart:async';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/data_sources/data_sources.dart' as data_sources;
import 'a_typed_model.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';

class ItemCopyModel extends AUuidBasedModel<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyModel');

  final CollectionsModel collectionsModel;
  final ItemTypeModel itemTypeModel;
  final AItemDataSource itemDataSource;
  final AItemTypeDataSource itemTypeDataSource;
  final AItemCopyDataSource itemCopyDataSource;
  final AFieldDataSource fieldDataSource;
  final ACollectionDataSource collectionDataSource;
  final AHistoryDataSource historyDataSource;

  ItemCopyModel(this.collectionsModel, this.historyDataSource, this.itemTypeModel, this.itemDataSource, this.collectionDataSource, this.itemCopyDataSource, this.itemTypeDataSource, this.fieldDataSource, AUserDataSource userDataSource): super(userDataSource);


  @override
  String get defaultWritePrivilegeRequirement => UserPrivilege.curator;
  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.none;

  @override
  AItemCopyDataSource get dataSource => itemCopyDataSource;


  @override
  Logger get loggerImpl => _log;

  @override
  Future<String> create(ItemCopy itemCopy,
      {bool bypassAuthentication: false, bool keepUuid: false}) async {
    itemCopy.status = ItemStatus.defaultStatus;
    return await super.create(itemCopy,
        bypassAuthentication: bypassAuthentication, keepUuid: keepUuid);
  }

  @override
  Future<Null> performAdjustments(ItemCopy itemCopy) async {
    itemCopy.eligibleActions = ItemAction.getEligibleActions(itemCopy.status);
    itemCopy.statusName = ItemStatus.getDisplayName(itemCopy.status);

    Collection col;
    if (itemCopy.collection != null)
      col = itemCopy.collection;
    else
      col = await collectionsModel.getByUuid(itemCopy.collectionUuid,
          bypassAuthentication: true);

    itemCopy.userCanCheckout = false;
    itemCopy.userCanEdit = false;

    if (userAuthenticated) {
      if (col.curatorUuids.contains(currentUserUuid)) {
        itemCopy.userCanEdit = await userHasPrivilege(UserPrivilege.curator);
        itemCopy.userCanCheckout =
            await userHasPrivilege(UserPrivilege.checkout);
      }
    }
  }

  Future<Null> _addSubObjects(List<ItemCopy> data,
      {bool includeCollection: false, bool includeItemSummary: false}) async {
    final UuidDataList<Collection> foundCollections =
        new UuidDataList<Collection>();

    final Map<String, ItemSummary> itemSummaries = <String, ItemSummary>{};

    for (ItemCopy itemCopy in data) {
      if (includeCollection) {
        if (!foundCollections.containsUuid(itemCopy.collectionUuid)) {
          final Option<Collection> collectionOpt = await collectionDataSource
              .getByUuid(itemCopy.collectionUuid);
          foundCollections.add(collectionOpt.getOrElse(() => throw new Exception(
              "Collection UUID ${itemCopy.collectionUuid} specified on item copy ${itemCopy.uuid} not found ")));
        }
        itemCopy.collection =
            foundCollections.getByUuid(itemCopy.collectionUuid).get();
      }
      // TODO: Make this more efficient, get it down to one call to the data source
      if (includeItemSummary) {
        if (!itemSummaries.containsKey(itemCopy.itemUuid)) {
          itemSummaries[itemCopy.itemUuid] = new ItemSummary.copyObject(
              (await itemDataSource.getByUuid(itemCopy.itemUuid)).getOrElse(() => throw new NotFoundException("Item not found for uuid ${itemCopy.uuid}")));
        }
        itemCopy.itemSummary = itemSummaries[itemCopy.itemUuid];
      }
    }
  }

  @override
  Future<ItemCopy> getByUuid(String uuid,
      {bool bypassAuthentication: false,
      bool includeItemSummary: false,
      bool includeCollection: false}) async {
    final ItemCopy itemCopy =
        await super.getByUuid(uuid, bypassAuthentication: bypassAuthentication);

    await _addSubObjects(<ItemCopy>[itemCopy],
        includeCollection: includeCollection,
        includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<ItemCopy> getByUniqueId(String uniqueId,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final Option<ItemCopy> optItemCopy =
        await itemCopyDataSource.getByUniqueId(uniqueId);

    final ItemCopy itemCopy = optItemCopy.getOrElse(() =>
        throw new NotFoundException(
            "Item copy with unique ID $uniqueId not found"));

    await performAdjustments(itemCopy);
    await _addSubObjects(<ItemCopy>[itemCopy],
        includeCollection: includeCollection,
        includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemUuid,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final List<ItemCopy> output =
        await itemCopyDataSource.getByItemUuid(itemUuid);

    for (ItemCopy ic in output) {
      await performAdjustments(ic);
    }

    await _addSubObjects(output, includeCollection: includeCollection);
    return output;
  }

  Future<ItemCopy> getVisible(String itemCopyUuid,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final ItemCopy itemCopy = await getByUuid(itemCopyUuid,
        includeItemSummary: includeItemSummary,
        includeCollection: includeCollection);

    final UuidDataList<Collection> visibleCollection = await collectionDataSource
        .getVisibleCollections(currentUserUuid);
    if (!visibleCollection.containsUuid(itemCopy.collectionUuid)) {
      throw new ForbiddenException();
    }
    return itemCopy;
  }

  Future<ItemCopy> getVisibleByUniqueId(String uniqueId,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final ItemCopy itemCopy = await getByUniqueId(uniqueId,
        includeItemSummary: includeItemSummary,
        includeCollection: includeCollection);

    final UuidDataList<Collection> visibleCollection = await collectionDataSource
        .getVisibleCollections(currentUserUuid);
    if (!visibleCollection.containsUuid(itemCopy.collectionUuid)) {
      throw new ForbiddenException();
    }
    return itemCopy;
  }

  Future<List<ItemCopy>> getVisibleForItem(String itemUuidOrReadableId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    String itemUuid;
    if (!isUuid(itemUuidOrReadableId)) {
      itemUuid =
          (await itemDataSource.getUuidForReadableId(itemUuidOrReadableId))
              .getOrElse(() => throw new NotFoundException(
                  "Item $itemUuidOrReadableId not found"));
    } else {
      itemUuid = itemUuidOrReadableId;
    }

    final List<ItemCopy> output = await itemCopyDataSource
        .getVisibleForItem(itemUuid, currentUserUuid);

    for (ItemCopy ic in output) {
      await performAdjustments(ic);
    }
    await _addSubObjects(output, includeCollection: includeCollection);
    return output;
  }

  Future<Null> performBulkAction(List<String> itemCopyUuids, String action,
      String actionerUserUuid) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .performValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(action)) {
        fieldErrors["action"] = "Required";
      } else if (!ItemAction.isValidAction(action)) {
        fieldErrors["action"] = "Invalid";
      }

      if (StringTools.isNullOrWhitespace(actionerUserUuid)) {
        fieldErrors["actionerUserUuid"] = "Required";
      } else {
        if (!await userDataSource.existsByUuid(actionerUserUuid))
          fieldErrors["actionerUserUuid"] = "Not found";
      }
    });

    // TODO: Validate that both the person checking out AND the person being checked out to have permission to take the item.
    final List<ItemCopy> copies =
        await itemCopyDataSource.getAllByUuids(itemCopyUuids);

    await ItemActionException
        .performValidation((Map<String, String> itemActionErrors) async {
      for (String itemCopyUuid in itemCopyUuids) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyUuid == ic.uuid) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          itemActionErrors[itemCopyUuid] = "Item copy not found";
        } else {
          if (!ItemAction.isActionValidForStatus(action, itemCopy.status)) {
            itemActionErrors[itemCopyUuid] = "Item is ${itemCopy.status}";
          }
        }
        return itemActionErrors;
      }
    });

    final String newStatus = ItemAction.getResultingStatus(action);
    await itemCopyDataSource.updateStatus(itemCopyUuids, newStatus);

    for (ItemCopy itemCopy in copies) {
      final ActionHistoryEntry historyEntry = new ActionHistoryEntry();
      historyEntry.action = action;
      historyEntry.actionerUserUuid = actionerUserUuid;
      historyEntry.itemCopyUuid = itemCopy.uuid;
      historyEntry.itemUuid = itemCopy.itemUuid;
      historyEntry.operatorUserUuid = currentUserUuid;

      itemCopy.status = newStatus;

      await historyDataSource.write(historyEntry);
    }
  }

  Future<Null> transfer(
      List<String> itemCopyUuids, String targetCollectionUuid) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .performValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(targetCollectionUuid)) {
        fieldErrors["targetCollectionUuid"] = "Required";
      } else {
        if (!await collectionDataSource
            .existsByUuid(targetCollectionUuid)) {
          fieldErrors["targetCollectionUuid"] = "Invalid";
        }
      }
    });

    // TODO: Validate that the user has permission to transfer to the target collection
    final List<ItemCopy> copies =
        await itemCopyDataSource.getAllByUuids(itemCopyUuids);

    await TransferException
        .performValidation((Map<String, String> transferErrors) async {
      for (String itemCopyId in itemCopyUuids) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyId == ic.uuid) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          transferErrors[itemCopyId] = "Item copy not found";
        } else if (itemCopy.collectionUuid == targetCollectionUuid) {
          transferErrors[itemCopyId] = "Item is already in collection";
        } else if (itemCopy.status != ItemStatus.available) {
          transferErrors[itemCopyId] = "Item is ${itemCopy.status}";
        }
        return transferErrors;
      }
    });

    await itemCopyDataSource
        .updateCollection(itemCopyUuids, targetCollectionUuid);

    for (ItemCopy itemCopy in copies) {
      final TransferHistoryEntry historyEntry = new TransferHistoryEntry();
      historyEntry.fromCollectionUuid = itemCopy.collectionUuid;
      historyEntry.toCollectionUuid = targetCollectionUuid;
      historyEntry.itemUuid = itemCopy.itemUuid;
      historyEntry.itemCopyUuid = itemCopy.uuid;
      historyEntry.operatorUserUuid = currentUserUuid;

      itemCopy.collectionUuid = targetCollectionUuid;

      await historyDataSource.write(historyEntry);
    }
  }

  @override
  Future<String> update(String uuid, ItemCopy itemCopy,
      {bool bypassAuthentication: false}) async {
    // TODO: Enforce item-level privilege?
    itemCopy.status = "";
    return await super
        .update(uuid, itemCopy, bypassAuthentication: bypassAuthentication);
  }

  @override
  Future<Map<String, String>> validateFields(ItemCopy itemCopy,
      {String existingId: null, bool skipItemIdCheck: false}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    if (!skipItemIdCheck) {
      if (StringTools.isNullOrWhitespace(itemCopy.itemUuid))
        fieldErrors["itemUuid"] = "Required";
      else {
        if (!await itemDataSource.existsByUuid(itemCopy.itemUuid))
          fieldErrors["itemUuid"] = "Not found";
      }
      final bool test = await itemCopyDataSource.existsByUuid(existingId);
      if (StringTools.isNullOrWhitespace(existingId)) {
        if (test) throw new InvalidInputException("Copy already exists");
      } else {
        if (!test) throw new NotFoundException("Specified copy not found");
      }
    }

    if (StringTools.isNullOrWhitespace(itemCopy.collectionUuid)) {
      fieldErrors["collectionUuid"] = "Required";
    } else {
      final Option<Collection> col =
          await collectionDataSource.getByUuid(itemCopy.collectionUuid);
      col.map((Collection col) {
        if (!col.curatorUuids.contains(this.currentUserUuid))
          fieldErrors["collectionUuid"] = "Not a curator";
      }).orElse(() {
        fieldErrors["collectionUuid"] = "Not found";
      });
    }

    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId)) {
      if (skipItemIdCheck) {
        if (await itemCopyDataSource.existsByUniqueId(itemCopy.uniqueId)) {
          fieldErrors["uniqueId"] = "Already used";
        }
      } else {
        final Option<ItemCopy> test =
            await itemCopyDataSource.getByUniqueId(itemCopy.uniqueId);
        test.map((ItemCopy testItemCopy) {
          if (testItemCopy.uuid != itemCopy.uuid)
            fieldErrors["uniqueId"] = "Already used";
        });
      }
    }

    if (StringTools.isNullOrWhitespace(existingId)) {
      if (StringTools.isNullOrWhitespace(itemCopy.status)) {
        fieldErrors["status"] = "Required";
      } else {
        if (!ItemStatus.isValidStatus(itemCopy.status))
          fieldErrors["status"] = "Invalid";
      }
    }

    return fieldErrors;
  }
}
