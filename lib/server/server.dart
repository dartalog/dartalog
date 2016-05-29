library dartalog.server;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';

part 'src/settings.dart';
part 'src/setting_names.dart';

final String ROOT_DIRECTORY = join(dirname(Platform.script.toFilePath()),'..');

String SERVER_ROOT, SERVER_API_ROOT;


Future<Map> loadJSONFile(String path) async {
  File dir = new File(path);
  String contents = await dir.readAsString();
  Map output = JSON.decode(contents);
  return output;
}