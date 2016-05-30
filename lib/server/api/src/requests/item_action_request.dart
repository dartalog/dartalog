part of api;

class ItemActionRequest {
  @ApiProperty(required: true)
  String action;

  @ApiProperty(required: true)
  String actionerUserId;


  ItemActionRequest();

  Future validate(ItemCopy itemCopy) async {
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
      User user = await model.users.getById(this.actionerUserId);
      if(user==null)
        field_errors["actionerUserId"] = "Not found";
    }


    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data", field_errors);
    }
  }
}
