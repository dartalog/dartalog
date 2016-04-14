part of api;

class PresetResource extends AResource {
  static final Logger _log = new Logger('PresetResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'presets/')
  Future<Map<String,String>> getAll() async {
    try {
      Map<String,String> output = await Model.presets.getAll();
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'presets/{uuid}/')
  Future<ItemTypeResponse> get(String uuid) async {
    try {
      ItemTypeResponse output = new ItemTypeResponse();
      output.itemType = await Model.presets.getPreset(uuid);
      if(output.itemType==null) {
        throw new NotFoundException("Could not find specified preset");
      }
      output.fields = await Model.presets.getFields(output.itemType.fields);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'presets/{uuid}/')
  Future<VoidMessage> install(String uuid, VoidMessage blank) async {
    try {
      await Model.presets.install(uuid);
      return null;
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

}