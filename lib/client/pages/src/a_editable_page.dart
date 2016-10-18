import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:dartalog/tools.dart';

abstract class AEditablePage {
  @Property(notify: true)
  bool get showEditButton {
    return !StringTools.isNullOrWhitespace(editLink);
  }

  @Property(notify: true)
  String get editLink => StringTools.empty;

  //Future edit();
}
