library server;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

part 'src/settings.dart';
part 'src/setting_names.dart';

Future<Map> loadJSONFile(String path) async {
  File dir = new File(path);
  String contents = await dir.readAsString();
  Map output = JSON.decode(contents);
  return output;
}