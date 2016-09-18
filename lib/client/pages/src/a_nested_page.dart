import 'dart:async';
import 'package:polymer/polymer.dart';
import 'a_page.dart';

abstract class ANestedPage<T extends APage> extends APage<T> {
  ANestedPage.created(String title) : super.created(title);


  @override
  Future activate() async {
    await super.activate();
  }


}