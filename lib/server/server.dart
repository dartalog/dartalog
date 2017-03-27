import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:angular2/di.dart';

export 'src/settings.dart';
export 'src/exceptions/setup_disabled_exception.dart';
export 'src/exceptions/setup_required_exception.dart';
export 'src/exceptions/not_authorized_exception.dart';

final String rootDirectory = join(dirname(Platform.script.toFilePath()), '..');
String serverRoot, serverApiRoot;

final String setupLockFilePath = "$rootDirectory/setup.lock";

Future<Map<String, dynamic>> loadJSONFile(String path) async {
  final File dir = new File(path);
  final String contents = await dir.readAsString();
  final Map<String, dynamic> output = JSON.decode(contents);
  return output;
}

//String getImagesRootUrl() {
//  return rpc.context.baseUrl + "/images/";
//}

enum SettingNames { itemNameFormat }
