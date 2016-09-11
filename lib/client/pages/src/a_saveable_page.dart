import 'dart:async';
import 'package:polymer/polymer.dart';

abstract class ASaveablePage {
  @Property(notify: true)
  bool showSaveButton = true;

  Future save();
}