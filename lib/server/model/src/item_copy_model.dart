part of model;

class ItemCopyModel extends AModel<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyModel');
  Logger get _logger => _log;

  Future<String> create(String itemId, ItemCopy itemCopy) async {
    itemCopy.itemId = itemId;
    itemCopy.status = ITEM_DEFAULT_STATUS;

    ItemCopy topItem = await data_sources.itemCopies.getLargestNumberedCopy(itemId);
    if(topItem==null)
      itemCopy.copy = 1;
    else
      itemCopy.copy = topItem.copy + 1;
    await validate(itemCopy, true);

    return await data_sources.itemCopies.write(itemCopy);
  }

  Future<List<ItemCopy>> getAllForItem(String itemId) => data_sources.itemCopies.getAllForItemId(itemId);

  Future<String> update(String itemId, int copy, ItemCopy itemCopy) async {
    itemCopy.status = "";
    await validate(itemCopy, false);
    return await data_sources.itemCopies.write(itemCopy, itemId, copy);
  }

  Future<ItemCopy> get(String itemId, int copy) async {
    ItemCopy itemCopy = await data_sources.itemCopies.getByItemIdAndCopy(itemId, copy);
    if(itemCopy==null)
      throw new NotFoundException("Copy #${copy} of ${itemId} not found");

    return itemCopy;
  }

  Future performAction(String itemId, int copy, String action, String actionerUserId) async {
    if(!userAuthenticated()) {
      throw new NotAuthorizedException();
    }

    ItemCopy itemCopy = await get(itemId, copy);

    await DataValidationException.PerformValidation(
        new Future.sync(() async {
          Map<String, String> field_errors = new Map<String, String>();

          if (isNullOrWhitespace(action)) {
            field_errors["action"] = "Required";
          } else if(!ITEM_ACTIONS.containsKey(action)) {
            field_errors["action"] = "Invalid";
          } else if(!ITEM_ACTIONS[action][ITEM_ACTION_VALID_STATUSES].contains(itemCopy.status)){
            field_errors["action"] = "Invalid for current status";
          }

          if (isNullOrWhitespace(actionerUserId)) {
            field_errors["actionerUserId"] = "Required";
          } else {
            User user = await data_sources.users.getById(actionerUserId);
            if(user==null)
              field_errors["actionerUserId"] = "Not found";
          }
        })
    );

    ItemCopyHistoryEntry historyEntry = new ItemCopyHistoryEntry();
    historyEntry.action = action;
    historyEntry.actionerUserId = actionerUserId;
    historyEntry.copy = itemCopy.copy;
    historyEntry.itemId = itemCopy.itemId;
    historyEntry.operatorUserId = getUserId();

    itemCopy.status = ITEM_ACTIONS[action][ITEM_ACTION_RESULTING_STATUS];

    await data_sources.itemHistories.write(historyEntry);
    await data_sources.itemCopies.write(itemCopy, itemId, copy);
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
      dynamic test = await data_sources.itemCopies.getByItemIdAndCopy(itemCopy.itemId, itemCopy.copy);
      if (creating) {
        if (test != null) throw new InvalidInputException("Copy already exists");
      } else {
        if (test == null) throw new NotFoundException("Specified copy not found");
      }
    }

    if(isNullOrWhitespace(itemCopy.collectionId)) {
      field_errors["collectionId"] = "Required";
    } else {
      dynamic test = await data_sources.itemCollections.getById(itemCopy.collectionId);
      if(test==null)
        field_errors["collectionId"] = "Not found";
    }

    if(!isNullOrWhitespace(itemCopy.uniqueId)) {
      dynamic test = await data_sources.itemCopies.getByUniqueId(itemCopy.uniqueId);
      if(test!=null&&(test.itemId!=itemCopy.itemId||test.copy!=itemCopy.copy))
        field_errors["uniqueId"] = "Already used";
    }

    if(creating) {
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