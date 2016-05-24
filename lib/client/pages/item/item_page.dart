// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_page.html")
library dartalog.client.pages.item_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('item-page')
class ItemPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("ItemPage");

  String currentItemId = "";

  @Property(notify: true)
  Item currentItem = new Item();

  ItemPage.created() : super.created("Item View");

  @override
  void activateInternal(Map args) {
    if(isNullOrWhitespace(args["itemId"])) {
      throw new Exception("itemId is required");
    }
    this.currentItemId = args["itemId"];
    this.refresh();
  }

  Future refresh() async {
    await loadItem();
  }

  Future loadItem() async {
    try {
      API.Item item = await api.items.get(this.currentItemId, expand: "type,type.fields");
      Item newItem = new Item.copy(item);
      set("currentItem", newItem);
      set("currentItem.fields",newItem.fields);
      setTitle(newItem.name);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }


}