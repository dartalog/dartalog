part of model;

class PresetModel extends _AModel {
  static final Logger _log = new Logger('PresetModel');

  PresetModel();



  Future<Map> _getItemTypePresets() async {
    return loadJSONFile("presets/item_types.json");
  }

  Future<Map> _getFieldPresets() async {
    return loadJSONFile("presets/fields.json");
  }

  Future<Map<String,String>> getAll() async {
    Map map = await _getItemTypePresets();
    Map<String,String> output = new Map<String,String>();
    for(String key in map.keys) {
      output[key] = map[key]["name"];
    }
    return output;
  }

  Future<api.ItemType> getPreset(String id) async {
    Map map = await _getItemTypePresets();
    if(!map.containsKey(id)) {
      throw new NotFoundException("Specified preset not found");
    }
    map = map[id];
    api.ItemType output = new api.ItemType();
    output.name = map["name"];
    output.fields = map["fields"];
    return output;
  }

  Future<Map<String,api.Field>> getFields(List<String> ids) async {
    Map field_presets = await _getFieldPresets();
    Map<String,api.Field> db_fields = await fields.getAllForIDs(ids);
    Map<String,api.Field> output = new Map<String, api.Field>();

    for(String field_id in ids) {
      api.Field field;
      if(db_fields.containsKey(field_id)) {
        field = db_fields[field_id];
      } else if(field_presets.containsKey(field_id)) {
        field = new api.Field.fromData(field_presets[field_id]);
        output[field_id] = field;
      } else {
        throw new Exception("Field ID ${field_id} not found in database or field presets");
      }
    }
    return output;
  }

  Future install(String id) async {
    var dbitem = await items.get(id);
    if(dbitem!=null) {
      throw new InvalidInputException("Preset is already installed");
    }
    api.ItemType itemType = await this.getPreset(id);

    Map field_presets = await _getFieldPresets();
    Map<String,api.Field> db_fields = await fields.getAllForIDs(itemType.fields);

    for(String field_id in itemType.fields) {
      if(!db_fields.containsKey(field_id)) {
        if(field_presets.containsKey(field_id)) {
        api.Field field = new api.Field.fromData(field_presets[field_id]);
        await fields.write(field, field_id, true);
      } else {
        throw new Exception(
            "Field ID ${field_id} not found in database or field presets");
      }
      }
    }

    await itemTypes.write(itemType, id, true);

  }
}