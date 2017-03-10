import 'package:dartalog/data/src/a_data.dart';
import 'dart:async';

class ImportSettings extends AData {
  String name;

  Map<String, String> fieldValues = new Map<String, String>();

  ImportSettings();

  Future validate() async {}
}
