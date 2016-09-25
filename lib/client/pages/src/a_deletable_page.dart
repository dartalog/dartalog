import 'dart:async';
import 'package:polymer/polymer.dart';

abstract class ADeletablePage {
  @Property(notify: true)
  bool showDeleteButton = true;

  Future delete();
}