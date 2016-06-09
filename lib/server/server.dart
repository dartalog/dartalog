library dartalog.server;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:rpc/rpc.dart' as rpc;

part 'src/settings.dart';
part 'src/setting_names.dart';
part 'src/setup_disabled_exception.dart';
part 'src/setup_required_exception.dart';

final String ROOT_DIRECTORY = join(dirname(Platform.script.toFilePath()),'..');
final String SETUP_LOCK_FILE_PATH = "${ROOT_DIRECTORY}/setup.lock";

String SERVER_ROOT, SERVER_API_ROOT;


//String getImagesRootUrl() {
//  return rpc.context.baseUrl + "/images/";
//}

Future<Map> loadJSONFile(String path) async {
  File dir = new File(path);
  String contents = await dir.readAsString();
  Map output = JSON.decode(contents);
  return output;
}