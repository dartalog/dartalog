// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_browse_page.html")
library dartalog.client.pages.item_browse_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_action_dialog.dart';
import 'package:paper_elements/paper_shadow.dart';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_dropdown.dart';
import 'package:paper_elements/paper_dropdown_menu.dart';
import 'package:core_elements/core_selector.dart';
import 'package:core_elements/core_menu.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../../api/dartalog.dart' as API;

/// A Polymer `<template-admin-page>` element.
@CustomTag('item-browse-page')
class ItemBrowsePage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("ItemBrowsePage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  ItemBrowsePage.created() : super.created("Item Browse");

  @observable Map items = new ObservableMap();

  void activateInternal(Map args) {
    this.refresh();
  }

  Future refresh() async {
    this.clear();
    await loadItems();
  }

  Future loadItems() async {
    try {
      items.clear();
      API.MapOfItem data = await api.items.getAll();
      items.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void clear() {
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }


  itemClicked(event, detail, target) async {
    try {
      String id = target.dataset["id"];
      window.location.hash = "item/${id}";
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }


}