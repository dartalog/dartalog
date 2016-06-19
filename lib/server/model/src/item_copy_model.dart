part of model;

class ItemCopyModel extends ATypedModel<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyModel');
  Logger get _logger => _log;

  @override
  String get _defaultWritePrivilegeRequirement => UserPrivilege.curator;

  Future<ItemCopyId> create(String itemId, ItemCopy itemCopy) async {
    if (!_userAuthenticated) {
      throw new NotAuthorizedException();
    }
    itemCopy.itemId = itemId;
    itemCopy.status = ITEM_DEFAULT_STATUS;

    itemCopy.copy = await data_sources.itemCopies.getNextCopyNumber(itemId);

    await validate(itemCopy, true);

    return await data_sources.itemCopies.write(itemCopy, false);
  }

  Future<ItemCopy> get(String itemId, int copy,
      {bool includeItem: false, bool includeCollection: false}) async {
    Option<ItemCopy> optItemCopy =
        await data_sources.itemCopies.getByItemIdAndCopy(itemId, copy);

    ItemCopy itemCopy = optItemCopy.getOrElse(() =>
        throw new NotFoundException("Copy #${copy} of ${itemId} not found"));

    itemCopy.itemId = itemId;

    if (includeItem) {
      itemCopy.item = (await items.getById(itemCopy.itemId));
    }
    if (includeCollection) {
      itemCopy.collection = (await collections.getById(itemCopy.collectionId));
    }

    await _setAdditionalFields(itemCopy);
    return itemCopy;
  }

  Future<List<ItemCopy>> getAllForItem(String itemId,
      {bool includeRemoved: false, bool includeCollection: false}) async {
    List<ItemCopy> output =
        await data_sources.itemCopies.getAllForItemId(itemId, userName: _currentUserId);
    IdNameList<Collection> foundCollections = new IdNameList<Collection>();
    for (ItemCopy itemCopy in output) {
      itemCopy.itemId = itemId;
      if (includeCollection) {
        if (!foundCollections.containsId(itemCopy.collectionId))
          foundCollections
              .add(await collections.getById(itemCopy.collectionId));
        itemCopy.collection =
            foundCollections.getByID(itemCopy.collectionId).get();
      }
      await _setAdditionalFields(itemCopy);
    }
    return output;
  }

  Future performBulkAction(List<ItemCopyId> itemCopyIds, String action,
      String actionerUserId) async {
    if (!_userAuthenticated) {
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
      if (!await data_sources.users.exists(actionerUserId))
        throw new InvalidInputException("User not found");
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
      historyEntry.operatorUserId = _currentUserId;

      itemCopy.status = newStatus;

      await data_sources.itemHistories.write(historyEntry);
    }
  }

  Future<ItemCopyId> update(String itemId, int copy, ItemCopy itemCopy) async {
    if (!_userAuthenticated) {
      throw new NotAuthorizedException();
    }
    itemCopy.status = "";
    await validate(itemCopy, false);
    return await data_sources.itemCopies.write(itemCopy, true);
  }

  Future _setAdditionalFields(ItemCopy itemCopy) async {
    for (String action in ITEM_ACTIONS.keys) {
      if (ITEM_ACTIONS[action].validStatuses.contains(itemCopy.status))
        itemCopy.eligibleActions.add(action);
    }
    itemCopy.statusName = ITEM_COPY_STATUSES[itemCopy.status];

    Collection col;
    if (itemCopy.collection != null)
      col = itemCopy.collection;
    else
      col = await collections.getById(itemCopy.collectionId, bypassAuth: true);

    itemCopy.userCanCheckout = false;
    itemCopy.userCanEdit = false;

    if (_userAuthenticated) {
      if (col.curators.contains(_currentUserId)) {
        itemCopy.userCanEdit = await _userHasPrivilege(UserPrivilege.curator);
        itemCopy.userCanCheckout =
            await _userHasPrivilege(UserPrivilege.checkout);
      }
    }
  }

  Future _validateFields(ItemCopy itemCopy, bool creating,
      {bool skipItemIdCheck: false}) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (!skipItemIdCheck) {
      if (isNullOrWhitespace(itemCopy.itemId))
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

    if (isNullOrWhitespace(itemCopy.collectionId)) {
      field_errors["collectionId"] = "Required";
    } else {
      Option<Collection> col =
          await data_sources.itemCollections.getById(itemCopy.collectionId);
      col.map((Collection col) {
        if (!col.curators.contains(this._currentUserId))
          field_errors["collectionId"] = "Not a curator";
      }).orElse(() {
        field_errors["collectionId"] = "Not found";
      });
    }

    if (!isNullOrWhitespace(itemCopy.uniqueId)) {
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
