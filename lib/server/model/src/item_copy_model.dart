import 'dart:async';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_typed_model.dart';

class ItemCopyModel extends ATypedModel<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyModel');
  @override
  String get defaultWritePrivilegeRequirement => UserPrivilege.curator;
  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.none;

  @override
  Logger get loggerImpl => _log;

  Future<String> create(String itemUuid, ItemCopy itemCopy) async {
    await validateCreatePrivileges();

    itemCopy.itemUuid = itemUuid;
    itemCopy.status = ItemStatus.defaultStatus;

    await validate(itemCopy);

    return await data_sources.itemCopies.create(generateUuid(), itemCopy);
  }

  Future<ItemCopy> get(String uuid,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final Option<ItemCopy> optItemCopy =
        await data_sources.itemCopies.getByUuid(uuid);

    final ItemCopy itemCopy = optItemCopy.getOrElse(
        () => throw new NotFoundException("Item copy $uuid not found"));

    await _setAdditionalFieldsOnList(<ItemCopy>[itemCopy],
        includeCollection: includeCollection,
        includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<ItemCopy> getByUniqueId(String uniqueId,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final Option<ItemCopy> optItemCopy =
        await data_sources.itemCopies.getByUniqueId(uniqueId);

    final ItemCopy itemCopy = optItemCopy.getOrElse(() =>
        throw new NotFoundException(
            "Item copy with unique ID $uniqueId not found"));

    await _setAdditionalFieldsOnList(<ItemCopy>[itemCopy],
        includeCollection: includeCollection,
        includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemUuid,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final List<ItemCopy> output =
        await data_sources.itemCopies.getByItemUuid(itemUuid);
    await _setAdditionalFieldsOnList(output,
        includeCollection: includeCollection);
    return output;
  }

  Future<ItemCopy> getVisible(String itemCopyUuid,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final ItemCopy itemCopy = await get(itemCopyUuid,
        includeItemSummary: includeItemSummary,
        includeCollection: includeCollection);

    final UuidDataList<Collection> visibleCollection =
        await data_sources.itemCollections.getVisibleCollections(currentUserUuid);
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

    final UuidDataList<Collection> visibleCollection =
        await data_sources.itemCollections.getVisibleCollections(currentUserUuid);
    if (!visibleCollection.containsUuid(itemCopy.collectionUuid)) {
      throw new ForbiddenException();
    }
    return itemCopy;
  }

  Future<List<ItemCopy>> getVisibleForItem(String itemUuid,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final List<ItemCopy> output = await data_sources.itemCopies
        .getVisibleForItem(itemUuid, currentUserUuid);
    await _setAdditionalFieldsOnList(output,
        includeCollection: includeCollection);
    return output;
  }

  Future<Null> performBulkAction(List<String> itemCopyUuids, String action,
      String actionerUserUuid) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .PerformValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(action)) {
        fieldErrors["action"] = "Required";
      } else if (!ItemAction.isValidAction(action)) {
        fieldErrors["action"] = "Invalid";
      }

      if (StringTools.isNullOrWhitespace(actionerUserUuid)) {
        fieldErrors["actionerUserUuid"] = "Required";
      } else {
        if (!await data_sources.users.existsByUuid(actionerUserUuid))
          fieldErrors["actionerUserUuid"] = "Not found";
      }
    });

    // TODO: Validate that both the person checking out AND the person being checked out to have permission to take the item.
    final List<ItemCopy> copies =
        await data_sources.itemCopies.getAllByUuids(itemCopyUuids);

    await ItemActionException
        .performValidation((Map<String, String> itemActionErrors) async {
      for (String itemCopyUuid in itemCopyUuids) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyUuid==ic.uuid) itemCopy = ic;
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
    await data_sources.itemCopies.updateStatus(itemCopyUuids, newStatus);

    for (ItemCopy itemCopy in copies) {
      final ActionHistoryEntry historyEntry = new ActionHistoryEntry();
      historyEntry.action = action;
      historyEntry.actionerUserUuid = actionerUserUuid;
      historyEntry.itemCopyUuid = itemCopy.uuid;
      historyEntry.itemUuid = itemCopy.itemUuid;
      historyEntry.operatorUserUuid = currentUserUuid;

      itemCopy.status = newStatus;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<Null> transfer(
      List<String> itemCopyUuids, String targetCollectionUuid) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .PerformValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(targetCollectionUuid)) {
        fieldErrors["targetCollectionUuid"] = "Required";
      } else {
        if (!await data_sources.itemCollections.existsByUuid(targetCollectionUuid)) {
          fieldErrors["targetCollectionUuid"] = "Invalid";
        }
      }
    });

    // TODO: Validate that the user has permission to transfer to the target collection
    final List<ItemCopy> copies =
        await data_sources.itemCopies.getAllByUuids(itemCopyUuids);

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

    await data_sources.itemCopies
        .updateCollection(itemCopyUuids, targetCollectionUuid);

    for (ItemCopy itemCopy in copies) {
      final TransferHistoryEntry historyEntry = new TransferHistoryEntry();
      historyEntry.fromCollectionUuid = itemCopy.collectionUuid;
      historyEntry.toCollectionUuid = targetCollectionUuid;
      historyEntry.itemUuid = itemCopy.itemUuid;
      historyEntry.itemCopyUuid = itemCopy.uuid;
      historyEntry.operatorUserUuid = currentUserUuid;

      itemCopy.collectionUuid = targetCollectionUuid;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<String> update(String uuid, ItemCopy itemCopy) async {
    // TODO: Enforce item-level privilage?
    await validateUpdatePrivileges(uuid);

    itemCopy.status = "";
    await validate(itemCopy, existingId: uuid);
    return await data_sources.itemCopies.update(uuid, itemCopy);
  }

  Future<Null> _setAdditionalFields(ItemCopy itemCopy) async {
    itemCopy.eligibleActions = ItemAction.getEligibleActions(itemCopy.status);
    itemCopy.statusName = ItemStatus.getDisplayName(itemCopy.status);

    Collection col;
    if (itemCopy.collection != null)
      col = itemCopy.collection;
    else
      col = await collections.getByUuid(itemCopy.collectionUuid, bypassAuth: true);

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

  Future<Null> _setAdditionalFieldsOnList(List<ItemCopy> data,
      {bool includeCollection: false, bool includeItemSummary: false}) async {
    final UuidDataList<Collection> foundCollections =
        new UuidDataList<Collection>();

    final Map<String, ItemSummary> itemSummaries = <String, ItemSummary>{};

    for (ItemCopy itemCopy in data) {
      if (includeCollection) {
        if (!foundCollections.containsUuid(itemCopy.collectionUuid)) {
          final Option<Collection> collectionOpt =
              await data_sources.itemCollections.getByUuid(itemCopy.collectionUuid);
          foundCollections.add(collectionOpt.getOrElse(() => throw new Exception(
              "Collection UUID ${itemCopy.collectionUuid} specified on item copy ${itemCopy.uuid} not found ")));
        }
        itemCopy.collection =
            foundCollections.getByUuid(itemCopy.collectionUuid).get();
      }
      // TODO: Make this more efficient, get it down to one call to the data source
      if (includeItemSummary) {
        if(!itemSummaries.containsKey(itemCopy.itemUuid)) {
          itemSummaries[itemCopy.itemUuid] =new ItemSummary.copyObject(await items.getByUuid(itemCopy.itemUuid));
        }
        itemCopy.itemSummary = itemSummaries[itemCopy.itemUuid];
      }

      await _setAdditionalFields(itemCopy);
    }
  }

  @override
  Future<Null> validateFields(ItemCopy itemCopy,
      {String existingId: null, bool skipItemIdCheck: false}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    if (!skipItemIdCheck) {
      if (StringTools.isNullOrWhitespace(itemCopy.itemUuid))
        fieldErrors["itemUuid"] = "Required";
      else {
        if (!await data_sources.items.existsByUuid(itemCopy.itemUuid))
          fieldErrors["itemUuid"] = "Not found";
      }
        final bool test = await data_sources.itemCopies
            .existsByUuid(existingId);
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
          await data_sources.itemCollections.getByUuid(itemCopy.collectionUuid);
      col.map((Collection col) {
        if (!col.curatorUuids.contains(this.currentUserUuid))
          fieldErrors["collectionUuid"] = "Not a curator";
      }).orElse(() {
        fieldErrors["collectionUuid"] = "Not found";
      });
    }

    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId)) {
      if (skipItemIdCheck) {
        if (await data_sources.itemCopies.existsByUniqueId(itemCopy.uniqueId)) {
          fieldErrors["uniqueId"] = "Already used";
        }
      } else {
        final Option<ItemCopy> test =
            await data_sources.itemCopies.getByUniqueId(itemCopy.uniqueId);
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
