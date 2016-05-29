part of api;

class ItemCopy extends AData {
  @ApiProperty(required: false)
  String itemId = "";
  @ApiProperty(required: true)
  int copy = 0;
  @ApiProperty(required: true)
  String collectionId = "";
  @ApiProperty(required: false)
  String uniqueId = "";
  @ApiProperty(required: false)
  String status = "";

  Collection collection;

  ItemCopy();

  void cleanUp() {
    this.uniqueId = this.uniqueId.trim();
  }

  ItemCopy.copyItem(ItemCopy o) {
    this.itemId = o.itemId;
    this.copy = o.copy;
    this.collectionId = o.collectionId;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

  Future _validateFields(bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(this.itemId))
      field_errors["itemId"] = "Required";
    else {
      dynamic test = await model.items.getById(this.itemId);
      if (test == null) field_errors["itemId"] = "Not found";
    }

    if (copy == 0)
      throw new Exception("Copy must be greater than 0");
    else {
      dynamic test = await model.itemCopies.getByItemIdAndCopy(this.itemId, this.copy);
      if (creating) {
        if (test != null) throw new Exception("Copy already exists");
      } else {
        if (test == null) throw new NotFoundError("Specified copy not found");
      }
    }

    if(isNullOrWhitespace(this.collectionId)) {
      field_errors["collectionId"] = "Required";
    } else {
      dynamic test = await model.itemCollections.getById(this.collectionId);
      if(test==null)
        field_errors["collectionId"] = "Not found";
    }

    if(!isNullOrWhitespace(this.uniqueId)) {
      dynamic test = await model.itemCopies.getByUniqueId(this.uniqueId);
      if(test!=null)
        field_errors["uniqueId"] = "Already used";
    }

    if(isNullOrWhitespace(this.status)) {
      field_errors["status"] = "Required";
    } else {
      if(!ITEM_COPY_STATUSES.containsKey(this.status))
        field_errors["status"] = "Invalid";
    }

    return field_errors;
  }
}
