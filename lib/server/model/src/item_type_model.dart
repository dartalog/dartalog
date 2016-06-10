part of model;

class ItemTypeModel extends AIdNameBasedModel<ItemType> {
  static final Logger _log = new Logger('ItemTypeModel');
  Logger get _logger => _log;
  AIdNameBasedDataSource<ItemType> get dataSource => data_sources.itemTypes;

  @override
  Future<ItemType> getById(String id, {bool includeFields: false}) async {
    ItemType output = await super.getById(id);
    if(includeFields) {
      output.fields = await data_sources.fields.getByIds(output.fieldIds);
    }
    return output;
  }

  @override
  Future _validateFieldsInternal(Map<String, String> field_errors, ItemType itemType, bool creating) async {
    if (itemType.fieldIds == null || itemType.fieldIds.length == 0)
      field_errors["fieldIds"] = "Required";
    else {
      List test = await data_sources.fields.getByIds(itemType.fieldIds);
      if(test.length!=itemType.fieldIds.length)
        field_errors["fieldIds"] = "Not found";
    }
  }

}