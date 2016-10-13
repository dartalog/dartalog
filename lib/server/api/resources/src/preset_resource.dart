import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/responses/responses.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'a_resource.dart';

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
