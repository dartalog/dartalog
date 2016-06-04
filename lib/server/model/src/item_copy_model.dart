part of model;

class ItemCopyModel extends AModel<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyModel');
  Logger get _logger => _log;

  Future<String> create(String itemId, ItemCopy itemCopy) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    itemCopy.itemId = itemId;
    itemCopy.status = ITEM_DEFAULT_STATUS;

    ItemCopy topItem =
        await data_sources.itemCopies.getLargestNumberedCopy(itemId);
    if (topItem == null)
      itemCopy.copy = 1;
    else
      itemCopy.copy = topItem.copy + 1;
    await validate(itemCopy, true);

    return await data_sources.itemCopies.write(itemCopy);
  }

  Future<ItemCopy> get(String itemId, int copy) async {
    ItemCopy itemCopy =
        await data_sources.itemCopies.getByItemIdAndCopy(itemId, copy);
    if (itemCopy == null)
      throw new NotFoundException("Copy #${copy} of ${itemId} not found");
    await _setAdditionalFields(itemCopy);

    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemId,
      {bool includeRemoved: false}) async {
    List<ItemCopy> output =
        await data_sources.itemCopies.getAllForItemId(itemId);
    for (ItemCopy itemCopy in output) {
      await _setAdditionalFields(itemCopy);
    }
    return output;
  }

  Future performBulkAction(List<ItemCopyId> itemCopyIds, String action,
      String actionerUserId) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }

    if (isNullOrWhitespace(action)) {
      throw new InvalidInputException("Action required");
    } else if (!ITEM_ACTIONS.containsKey(action)) {
      throw new InvalidInputException("Action invalid");
    }

    if (isNullOrWhitespace(actionerUserId)) {
      throw new InvalidInputException("User is required");
    } else {
      User user = await data_sources.users.getById(actionerUserId);
      if (user == null) throw new InvalidInputException("User not found");
    }

    List<ItemCopy> copies = await data_sources.itemCopies.getAll(itemCopyIds);

    await ItemActionException.PerformValidation(() async {
      Map<ItemCopyId, String> item_action_errors =
          new Map<ItemCopyId, String>();

      for (ItemCopyId itemCopyId in itemCopyIds) {
        ItemCopy itemCopy;
        for (ItemCopy ic in copies) {
          if (itemCopyId.matchesItemCopy(ic)) itemCopy = ic;
          break;
        }
        if (itemCopy == null) {
          item_action_errors[itemCopyId] = "Item copy not found";
        } else {
          if (!ITEM_ACTIONS[action].validStatuses.contains(itemCopy.status)) {
            item_action_errors[itemCopyId] =
                "Cannot perform action ${action} when item is in status ${itemCopy.status}";
          }
        }
      }
    });

    String newStatus = ITEM_ACTIONS[action].resultingStatus;
    data_sources.itemCopies.updateStatus(itemCopyIds, newStatus);

    for (ItemCopy itemCopy in copies) {
      ItemCopyHistoryEntry historyEntry = new ItemCopyHistoryEntry();
      historyEntry.action = action;
      historyEntry.actionerUserId = actionerUserId;
      historyEntry.copy = itemCopy.copy;
      historyEntry.itemId = itemCopy.itemId;
      historyEntry.operatorUserId = getUserId();

      itemCopy.status = newStatus;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<String> update(String itemId, int copy, ItemCopy itemCopy) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    itemCopy.status = "";
    await validate(itemCopy, false);
    return await data_sources.itemCopies.write(itemCopy, itemId, copy);
  }

  Future _setAdditionalFields(ItemCopy itemCopy) async {
    for (String action in ITEM_ACTIONS.keys) {
      if (ITEM_ACTIONS[action].validStatuses.contains(itemCopy.status))
        itemCopy.eligibleActions.add(action);
    }
    itemCopy.statusName = ITEM_COPY_STATUSES[itemCopy.status];
    Collection col = await data_sources.itemCollections.getById(itemCopy.collectionId);
    if(col==null)
      throw new Exception("Collection ${itemCopy.collectionId} could not be found");

    itemCopy.collectionName = col.name;

    Item item = await data_sources.items.getById(itemCopy.itemId);
    itemCopy.itemName = item.name;
  }

  Future _validateFields(ItemCopy itemCopy, bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(itemCopy.itemId))
      field_errors["itemId"] = "Required";
    else {
      dynamic test = await data_sources.items.getById(itemCopy.itemId);
      if (test == null) field_errors["itemId"] = "Not found";
    }

    if (itemCopy.copy == 0)
      throw new Exception("Copy must be greater than 0");
    else {
      dynamic test = await data_sources.itemCopies
          .getByItemIdAndCopy(itemCopy.itemId, itemCopy.copy);
      if (creating) {
        if (test != null)
          throw new InvalidInputException("Copy already exists");
      } else {
        if (test == null)
          throw new NotFoundException("Specified copy not found");
      }
    }

    if (isNullOrWhitespace(itemCopy.collectionId)) {
      field_errors["collectionId"] = "Required";
    } else {
      dynamic test =
          await data_sources.itemCollections.getById(itemCopy.collectionId);
      if (test == null) field_errors["collectionId"] = "Not found";
    }

    if (!isNullOrWhitespace(itemCopy.uniqueId)) {
      dynamic test =
          await data_sources.itemCopies.getByUniqueId(itemCopy.uniqueId);
      if (test != null &&
          (test.itemId != itemCopy.itemId || test.copy != itemCopy.copy))
        field_errors["uniqueId"] = "Already used";
    }

    if (creating) {
      if (isNullOrWhitespace(itemCopy.status)) {
        field_errors["status"] = "Required";
      } else {
        if (!ITEM_COPY_STATUSES.containsKey(itemCopy.status))
          field_errors["status"] = "Invalid";
      }
    }

    return field_errors;
  }
}
