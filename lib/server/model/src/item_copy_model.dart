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
  Logger get childLogger => _log;

  Future<ItemCopyId> create(String itemId, ItemCopy itemCopy) async {
    await validateCreatePrivileges();

    itemCopy.itemId = itemId;
    itemCopy.status = ItemStatus.defaultStatus;

    itemCopy.copy = await data_sources.itemCopies.getNextCopyNumber(itemId);

    await validate(itemCopy, true);

    return await data_sources.itemCopies.write(itemCopy, false);
  }

  Future<ItemCopy> get(String itemId, int copy,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    Option<ItemCopy> optItemCopy =
        await data_sources.itemCopies.getByItemIdAndCopy(itemId, copy);

    ItemCopy itemCopy = optItemCopy.getOrElse(() =>
        throw new NotFoundException("Copy #${copy} of ${itemId} not found"));

    if (includeItemSummary) {
      itemCopy.itemSummary =
          new ItemSummary.copy(await items.getById(itemCopy.itemId));
    }

    await _setAdditionalFieldsOnList([itemCopy], itemId,
        includeCollection: includeCollection);

    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    List<ItemCopy> output =
        await data_sources.itemCopies.getAllForItemId(itemId);
    await _setAdditionalFieldsOnList(output, itemId,
        includeCollection: includeCollection);
    return output;
  }

  Future<ItemCopy> getVisible(String itemId, int copy,
      {bool includeItemSummary: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    ItemCopy itemCopy = await get(itemId, copy,
        includeItemSummary: includeItemSummary,
        includeCollection: includeCollection);

    IdNameList<Collection> visibleCollection =
        await data_sources.itemCollections.getVisibleCollections(currentUserId);
    if (!visibleCollection.containsId(itemCopy.collectionId)) {
      throw new ForbiddenException();
    }
    return itemCopy;
  }

  Future<List<ItemCopy>> getVisibleForItem(String itemId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    await validateGetPrivileges();

    List<ItemCopy> output = await data_sources.itemCopies
        .getVisibleForItemId(itemId, currentUserId);
    await _setAdditionalFieldsOnList(output, itemId,
        includeCollection: includeCollection);
    return output;
  }

  Future performBulkAction(List<ItemCopyId> itemCopyIds, String action,
      String actionerUserId) async {
    // TODO: Pre-validate privileges for all requested items as one command?
    await validateUpdatePrivileges(null);

    await DataValidationException
        .PerformValidation((Map<String, String> field_errors) async {
      if (StringTools.isNullOrWhitespace(action)) {
        field_errors["action"] = "Required";
      } else if (!ItemAction.isValidAction(action)) {
        field_errors["action"] = "Invalid";
      }

      if (StringTools.isNullOrWhitespace(actionerUserId)) {
        field_errors["user"] = "Required";
      } else {
        if (!await data_sources.users.existsByID(actionerUserId))
          field_errors["user"] = "Not found";
      }
    });

    // TODO: Validate that both the person checking out AND the person being checked out to have permission to take the item.
    List<ItemCopy> copies = await data_sources.itemCopies.getAll(itemCopyIds);

    await ItemActionException
        .PerformValidation((Map<ItemCopyId, String> item_action_errors) async {
      for (ItemCopyId itemCopyId in itemCopyIds) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyId.matchesItemCopy(ic)) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          item_action_errors[itemCopyId] = "Item copy not found";
        } else {
          if (!ItemAction.isActionValidForStatus(action, itemCopy.status)) {
            item_action_errors[itemCopyId] = "Item is ${itemCopy.status}";
          }
        }
        return item_action_errors;
      }
    });

    String newStatus = ItemAction.getResultingStatus(action);
    data_sources.itemCopies.updateStatus(itemCopyIds, newStatus);

    for (ItemCopy itemCopy in copies) {
      ItemCopyHistoryEntry historyEntry = new ItemCopyHistoryEntry();
      historyEntry.action = action;
      historyEntry.actionerUserId = actionerUserId;
      historyEntry.copy = itemCopy.copy;
      historyEntry.itemId = itemCopy.itemId;
      historyEntry.operatorUserId = currentUserId;

      itemCopy.status = newStatus;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<ItemCopyId> update(String itemId, int copy, ItemCopy itemCopy) async {
    await validateUpdatePrivileges(itemId);

    itemCopy.status = "";
    await validate(itemCopy, false);
    return await data_sources.itemCopies.write(itemCopy, true);
  }

  Future _setAdditionalFields(ItemCopy itemCopy) async {
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

  Future _setAdditionalFieldsOnList(List<ItemCopy> data, String itemId,
      {bool includeCollection: false}) async {
    IdNameList<Collection> foundCollections = new IdNameList<Collection>();
    for (ItemCopy itemCopy in data) {
      itemCopy.itemId = itemId;
      if (includeCollection) {
        if (!foundCollections.containsId(itemCopy.collectionId)) {
          Option<Collection> collectionOpt =
              await data_sources.itemCollections.getById(itemCopy.collectionId);
          foundCollections.add(collectionOpt.getOrElse(() => throw new Exception(
              "Collection ID ${itemCopy.collectionId} specified on item ${itemId} copy ${itemCopy.copy} not found ")));
        }
        itemCopy.collection =
            foundCollections.getByID(itemCopy.collectionId).get();
      }
      await _setAdditionalFields(itemCopy);
    }
  }

  @override
  Future validateFields(ItemCopy itemCopy, bool creating,
      {bool skipItemIdCheck: false}) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (!skipItemIdCheck) {
      if (StringTools.isNullOrWhitespace(itemCopy.itemId))
        field_errors["itemId"] = "Required";
      else {
        dynamic test = await data_sources.items.getById(itemCopy.itemId);
        if (test == null) field_errors["itemId"] = "Not found";
      }
      if (itemCopy.copy == 0)
        throw new Exception("Copy must be greater than 0");
      else {
        bool test = await data_sources.itemCopies
            .existsByItemIdAndCopy(itemCopy.itemId, itemCopy.copy);
        if (creating) {
          if (test) throw new InvalidInputException("Copy already exists");
        } else {
          if (!test) throw new NotFoundException("Specified copy not found");
        }
      }
    }

    if (StringTools.isNullOrWhitespace(itemCopy.collectionId)) {
      field_errors["collectionId"] = "Required";
    } else {
      Option<Collection> col =
          await data_sources.itemCollections.getById(itemCopy.collectionId);
      col.map((Collection col) {
        if (!col.curators.contains(this.currentUserId))
          field_errors["collectionId"] = "Not a curator";
      }).orElse(() {
        field_errors["collectionId"] = "Not found";
      });
    }

    if (!StringTools.isNullOrWhitespace(itemCopy.uniqueId)) {
      if (skipItemIdCheck) {
        if (await data_sources.itemCopies.existsByUniqueId(itemCopy.uniqueId)) {
          field_errors["uniqueId"] = "Already used";
        }
      } else {
        Option<ItemCopy> test =
            await data_sources.itemCopies.getByUniqueId(itemCopy.uniqueId);
        test.map((ItemCopy testItemCopy) {
          if (testItemCopy.itemId != itemCopy.itemId ||
              testItemCopy.copy != itemCopy.copy)
            field_errors["uniqueId"] = "Already used";
        });
      }
    }

    if (creating) {
      if (StringTools.isNullOrWhitespace(itemCopy.status)) {
        field_errors["status"] = "Required";
      } else {
        if (!ItemStatus.isValidStatus(itemCopy.status))
          field_errors["status"] = "Invalid";
      }
    }

    return field_errors;
  }
}
