// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('combo_list_control.html')
library dartalog.client.controls.combo_list;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/paper_tooltip.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

@PolymerRegister('combo-list-control')
class ComboListControl extends AControl  {
  static final Logger _log = new Logger("ComboListControl");

  Logger get loggerImpl => _log;

  @property String errorMessage= "";
  @property bool invalid = false;

  @property
  String label = "";

  @property
  List items = [];

  @property
  List selectedItems = [];

  @property
  List<String> selectedValues = [];

  @Property(notify: true)
  String selectedItem;

  @property
  bool allowOrdering = false;

  ComboListControl.created() : super.created();

  @reflectable
  bool isFirst(int index) => index==0;
  @reflectable
  bool isLast(int index) => index==(selectedItems.length-1);

  @Observe('selectedValues.*')
  void usersChanged(Map changeRecord) {
    clear("selectedItems");
    for(String id in changeRecord['base']) {
      _getItem(id).map((item) {
        if(!selectedItems.contains(item))
          add("selectedItems", item);
      }).orElse(() => throw new Exception("ID ${id} not found in available item list"));
    }
  }

  Option _getItem(String id) {
    for(dynamic i in items) {
      if(i.id==id)
        return new Some(i);
    }
    return new None();
  }

  @reflectable
  Future addClicked(event, [_]) async {
    try {
      String id = this.selectedItem;

      if(isNullOrWhitespace(id))
        throw new Exception("Please select an item");


      dynamic item = _getItem(id).getOrElse(() => throw new Exception("Selected item not found"));

      if(selectedValues.contains(id))
        throw new Exception("Item has already been added");

      add("selectedValues",id);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }
  @reflectable
  Future removeClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target, "paper-item");
      String id = ele.dataset["id"];

      if(id==null){
        throw new Exception("null id");
      }


      if(selectedValues.contains(id))
        removeItem("selectedValues", id);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }

  }

  @reflectable
  Future upClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target, "paper-item");
      int index = int.parse(ele.dataset["index"]);

      if(index==null){
        throw new Exception("null index");
      }

      if(index==0)
        return;

      dynamic item = removeAt("selectedValues", index);
      insert("selectedValues", index-1, item);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }

  }

  setInvalid(bool value) {
    set("invalid", value);
  }
  setGeneralErrorMessage(String  value) {
    set("errorMessage", value);
  }

  @reflectable
  Future downClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target, "paper-item");
      int index = int.parse(ele.dataset["index"]);

      if(index==null){
        throw new Exception("null index");
      }

      if(index==selectedValues.length-1)
        return;

      dynamic item = removeAt("selectedValues", index);
      insert("selectedValues", index+1, item);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }

  }
}