import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart' as model;
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class PresetResource extends AResource {
  static final Logger _log = new Logger('PresetResource');

  @override
  Logger get childLogger => _log;

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
//      output.itemType = await services.presets.getPreset(uuid);
//      if(output.itemType==null) {
//        throw new services.NotFoundException("Could not find specified preset");
//      }
//      output.fields = await services.presets.getFields(output.itemType.fields);
//      return output;
//    } catch (e, st) {
//      _HandleException(e, st);
//    }
//  }
//
//  @ApiMethod(method: 'POST', path: 'presets/{uuid}/')
//  Future<VoidMessage> install(String uuid, VoidMessage blank) async {
//    try {
//      await services.presets.install(uuid);
//      return null;
//    } catch(e,st) {
//      _HandleException(e, st);
//    }
//  }

}
