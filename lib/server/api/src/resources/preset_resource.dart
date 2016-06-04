part of api;

class PresetResource extends AResource {
  static final Logger _log = new Logger('PresetResource');
  Logger get _logger => _log;

//  @ApiMethod(path: 'presets/')
//  Future<Map<String, String>> getAll() async {
//    try {
//      Map<String, String> output = await model.presets.getAll();
//      return output;
//    } catch (e, st) {
//      _HandleException(e, st);
//    }
//  }
//
//  @ApiMethod(path: 'presets/{uuid}/')
//  Future<ItemTypeResponse> get(String uuid) async {
//    try {
//      ItemTypeResponse output = new ItemTypeResponse();
//      output.itemType = await data_sources.presets.getPreset(uuid);
//      if(output.itemType==null) {
//        throw new data_sources.NotFoundException("Could not find specified preset");
//      }
//      output.fields = await data_sources.presets.getFields(output.itemType.fields);
//      return output;
//    } catch (e, st) {
//      _HandleException(e, st);
//    }
//  }
//
//  @ApiMethod(method: 'POST', path: 'presets/{uuid}/')
//  Future<VoidMessage> install(String uuid, VoidMessage blank) async {
//    try {
//      await data_sources.presets.install(uuid);
//      return null;
//    } catch(e,st) {
//      _HandleException(e, st);
//    }
//  }

}
