import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

export 'src/settings.dart';
export 'src/exceptions/setup_disabled_exception.dart';
export 'src/exceptions/setup_required_exception.dart';
export 'src/exceptions/not_authorized_exception.dart';

final String ROOT_DIRECTORY = join(dirname(Platform.script.toFilePath()), '..');
String SERVER_ROOT, SERVER_API_ROOT;

final String SETUP_LOCK_FILE_PATH = "${ROOT_DIRECTORY}/setup.lock";

Future<Map> loadJSONFile(String path) async {
  File dir = new File(path);
  String contents = await dir.readAsString();
  Map output = JSON.decode(contents);
  return output;
}

//String getImagesRootUrl() {
//  return rpc.context.baseUrl + "/images/";
//}

enum SettingNames { ITEM_NAME_FORMAT }
