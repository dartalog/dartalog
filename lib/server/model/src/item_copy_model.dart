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

  Future<ItemCopyId> create(String itemId, ItemCopy itemCopy) async {
    await validateCreatePrivileges();

    itemCopy.itemId = itemId;
    itemCopy.status = ItemStatus.defaultStatus;

    itemCopy.copy = await data_sources.itemCopies.getNextCopyNumber(itemId);

    await validate(itemCopy);

    return await data_sources.itemCopies.write(itemCopy, false);
  }

  Future<ItemCopy> get(String itemId, int copy,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final Option<ItemCopy> optItemCopy =
        await data_sources.itemCopies.getByItemIdAndCopy(itemId, copy);

    final ItemCopy itemCopy = optItemCopy.getOrElse(() =>
        throw new NotFoundException("Copy #$copy of $itemId not found"));

    await _setAdditionalFieldsOnList(<ItemCopy>[itemCopy], itemId,
        includeCollection: includeCollection, includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<ItemCopy> getByUniqueId(String uniqueId,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final Option<ItemCopy> optItemCopy =
    await data_sources.itemCopies.getByUniqueId(uniqueId);

    final ItemCopy itemCopy = optItemCopy.getOrElse(() =>
    throw new NotFoundException("Item copy with unique ID $uniqueId not found"));

    await _setAdditionalFieldsOnList(<ItemCopy>[itemCopy], itemCopy.itemId,
        includeCollection: includeCollection, includeItemSummary: includeItemSummary);

    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final List<ItemCopy> output =
        await data_sources.itemCopies.getAllForItemId(itemId);
    await _setAdditionalFieldsOnList(output, itemId,
        includeCollection: includeCollection);
    return output;
  }

  Future<ItemCopy> getVisible(String itemId, int copy,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final ItemCopy itemCopy = await get(itemId, copy,
        includeItemSummary: includeItemSummary,
        includeCollection: includeCollection);

    final UuidDataList<Collection> visibleCollection =
        await data_sources.itemCollections.getVisibleCollections(currentUserId);
    if (!visibleCollection.containsId(itemCopy.collectionId)) {
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
    await data_sources.itemCollections.getVisibleCollections(currentUserId);
    if (!visibleCollection.containsId(itemCopy.collectionId)) {
      throw new ForbiddenException();
    }
    return itemCopy;
  }


  Future<List<ItemCopy>> getVisibleForItem(String itemId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    final List<ItemCopy> output = await data_sources.itemCopies
        .getVisibleForItemId(itemId, currentUserId);
    await _setAdditionalFieldsOnList(output, itemId,
        includeCollection: includeCollection);
    return output;
  }

  Future<Null> performBulkAction(List<ItemCopyId> itemCopyIds, String action,
      String actionerUserId) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .PerformValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(action)) {
        fieldErrors["action"] = "Required";
      } else if (!ItemAction.isValidAction(action)) {
        fieldErrors["action"] = "Invalid";
      }

      if (StringTools.isNullOrWhitespace(actionerUserId)) {
        fieldErrors["user"] = "Required";
      } else {
        if (!await data_sources.users.existsByID(actionerUserId))
          fieldErrors["user"] = "Not found";
      }
    });

    // TODO: Validate that both the person checking out AND the person being checked out to have permission to take the item.
    final List<ItemCopy> copies = await data_sources.itemCopies.getAll(itemCopyIds);

    await ItemActionException
        .performValidation((Map<ItemCopyId, String> itemActionErrors) async {
      for (ItemCopyId itemCopyId in itemCopyIds) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyId.matchesItemCopy(ic)) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          itemActionErrors[itemCopyId] = "Item copy not found";
        } else {
          if (!ItemAction.isActionValidForStatus(action, itemCopy.status)) {
            itemActionErrors[itemCopyId] = "Item is ${itemCopy.status}";
          }
        }
        return itemActionErrors;
      }
    });

    final String newStatus = ItemAction.getResultingStatus(action);
    await data_sources.itemCopies.updateStatus(itemCopyIds, newStatus);

    for (ItemCopy itemCopy in copies) {
      final ActionHistoryEntry historyEntry = new ActionHistoryEntry();
      historyEntry.action = action;
      historyEntry.actionerUserId = actionerUserId;
      historyEntry.copy = itemCopy.copy;
      historyEntry.itemId = itemCopy.itemId;
      historyEntry.operatorUserId = currentUserId;

      itemCopy.status = newStatus;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<Null> transfer(List<ItemCopyId> itemCopyIds, String targetCollection) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .PerformValidation((Map<String, String> fieldErrors) async {
      if(StringTools.isNullOrWhitespace(targetCollection)) {
        fieldErrors["targetCollection"] ="Required";
      } else {
        if(!await data_sources.itemCollections.existsByID(targetCollection)) {
          fieldErrors["targetCollection"] ="Invalid";
        }
      }
    });

    // TODO: Validate that the user has permission to transfer to the target collection
    final List<ItemCopy> copies = await data_sources.itemCopies.getAll(itemCopyIds);

    await TransferException
        .performValidation((Map<ItemCopyId, String> transferErrors) async {
      for (ItemCopyId itemCopyId in itemCopyIds) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyId.matchesItemCopy(ic)) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          transferErrors[itemCopyId] = "Item copy not found";
        } else if(itemCopy.collectionId==targetCollection) {
          transferErrors[itemCopyId] = "Item is already in collection";
        } else if(itemCopy.status!= ItemStatus.available) {
          transferErrors[itemCopyId] = "Item is ${itemCopy.status}";
        }
        return transferErrors;
      }
    });

    await data_sources.itemCopies.updateCollection(itemCopyIds, targetCollection);

    for (ItemCopy itemCopy in copies) {
      final TransferHistoryEntry historyEntry = new TransferHistoryEntry();
      historyEntry.fromCollection = itemCopy.collectionId;
      historyEntry.toCollection = targetCollection;
      historyEntry.copy = itemCopy.copy;
      historyEntry.itemId = itemCopy.itemId;
      historyEntry.operatorUserId = currentUserId;

      itemCopy.collectionId = targetCollection;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<ItemCopyId> update(String itemId, int copy, ItemCopy itemCopy) async {
    await validateUpdatePrivileges(itemId);

    itemCopy.status = "";
    await validate(itemCopy, existingId:  itemId);
    return await data_sources.itemCopies.write(itemCopy, true);
  }

  Future<Null> _setAdditionalFields(ItemCopy itemCopy) async {
    itemCopy.eligibleActions = ItemAction.getEligibleActions(itemCopy.status);
    itemCopy.statusName = ItemStatus.getDisplayName(itemCopy.status);

    Collection col;
    if (itemCopy.collection != null)
      col = itemCopy.collection;
    else
      col = await collections.getById(itemCopy.collectionId, bypassAuth: true);

    itemCopy.userCanCheckout = false;
    itemCopy.userCanEdit = false;

    if (userAuthenticated) {
      if (col.curators.contains(currentUserId)) {
        itemCopy.userCanEdit = await userHasPrivilege(UserPrivilege.curator);
        itemCopy.userCanCheckout =
            await userHasPrivilege(UserPrivilege.checkout);
      }
    }
  }

  Future<Null> _setAdditionalFieldsOnList(List<ItemCopy> data, String itemId,
      {bool includeCollection: false, bool includeItemSummary: false}) async {

    final UuidDataList<Collection> foundCollections = new UuidDataList<Collection>();

    ItemSummary itemSummary;
    if (includeItemSummary) {
      itemSummary = new ItemSummary.copyObject(await items.getById(itemId));
    }

    for (ItemCopy itemCopy in data) {
      itemCopy.itemId = itemId;
      if (includeCollection) {
        if (!foundCollections.containsId(itemCopy.collectionId)) {
          final Option<Collection> collectionOpt =
              await data_sources.itemCollections.getById(itemCopy.collectionId);
          foundCollections.add(collectionOpt.getOrElse(() => throw new Exception(
              "Collection ID ${itemCopy.collectionId} specified on item $itemId copy ${itemCopy.copy} not found ")));
        }
        itemCopy.collection =
            foundCollections.getByID(itemCopy.collectionId).get();
      }
      if (includeItemSummary) {
        itemCopy.itemSummary = itemSummary;
      }


      await _setAdditionalFields(itemCopy);
    }
  }

  @override
  Future<Null> validateFields(ItemCopy itemCopy,
      {String existingId: null, bool skipItemIdCheck: false}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    if (!skipItemIdCheck) {
      if (StringTools.isNullOrWhitespace(itemCopy.itemId))
        fieldErrors["itemId"] = "Required";
      else {
        if(!await data_sources.items.existsByID(itemCopy.itemId))
          fieldErrors["itemId"] = "Not found";
      }
      if (itemCopy.copy == 0)
        throw new Exception("Copy must be greater than 0");
      else {
        final bool test = await data_sources.itemCopies
            .existsByItemIdAndCopy(itemCopy.itemId, itemCopy.copy);
        if (StringTools.isNullOrWhitespace(existingId)) {
          if (test) throw new InvalidInputException("Copy already exists");
        } else {
          if (!test) throw new NotFoundException("Specified copy not found");
        }
      }
    }

    if (StringTools.isNullOrWhitespace(itemCopy.collectionId)) {
      fieldErrors["collectionId"] = "Required";
    } else {
      final Option<Collection> col =
          await data_sources.itemCollections.getById(itemCopy.collectionId);
      col.map((Collection col) {
        if (!col.curators.contains(this.currentUserId))
          fieldErrors["collectionId"] = "Not a curator";
      }).orElse(() {
        fieldErrors["collectionId"] = "Not found";
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
          if (testItemCopy.itemId != itemCopy.itemId ||
              testItemCopy.copy != itemCopy.copy)
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
