// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_type_admin_page.html")
library dartalog.client.pages.template_admin_page;

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
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/combo_list/combo_list_control.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';

@PolymerRegister('item-type-admin-page')
class ItemTypeAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("ItemTypeAdminPage");
  Logger get loggerImpl => _log;

  ItemTypeAdminPage.created() : super.created( "Item Type Admin");

  @Property(notify: true)
  List<IdNamePair> itemTypes = new List<IdNamePair>();

  @Property(notify: true)
  List<IdNamePair> fields = new List<IdNamePair>();

  @property ItemType currentItemType = new ItemType();
  String currentItemId = "";

  @property String selectedField = "";

  PaperDialog get editDialog =>  this.querySelector('#editDialog');

  @override
  void setGeneralErrorMessage(String message) => set("errorMessage", message);
  @Property(notify:true)
  String errorMessage = "";

  @property
  bool userHasAccess = false;

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");

  Future activateInternal(Map args) async {
    bool authed = authWrapper.evaluateAuthentication();
    if(authed)
      await this.refresh();
    this.showRefreshButton = authed;
    this.showAddButton = authed;
  }

  Future refresh() async {
    this.reset();
    await loadAvailableFields();
    await loadItemTypes();
  }

  Future loadAvailableFields() async {
    await handleApiExceptions(() async {
      clear("fields");

      API.ListOfIdNamePair data = await api.fields.getAllIdsAndNames();

      set("fields", IdNamePair.copyList(data));
    });
  }

  Future loadItemTypes() async {
    await handleApiExceptions(() async {
      clear("itemTypes");
      API.ListOfIdNamePair data = await api.itemTypes.getAllIdsAndNames();
      set("itemTypes", IdNamePair.copyList(data));
    });
  }

  void reset() {
    set("currentItemType", new ItemType());
    currentItemId = "";
    clearValidation();
  }

  @override
  Future newItem() async {
    try {
      this.reset();
      openDialog(editDialog);
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel();
    this.reset();
  }

  @reflectable
  itemTypeClicked(event, [_]) async {
    await handleApiExceptions(() async {
      String id = event.target.dataset["id"];
      API.ItemType itemType = await api.itemTypes.getById(id);

      if(itemType==null)
        return;

      currentItemId = id;
      set("currentItemType", new ItemType.copy(itemType));
      openDialog(editDialog);
    });
  }


  @reflectable
  saveClicked(event, [_]) async {
    await handleApiExceptions(() async {
      API.ItemType itemType = new API.ItemType();
      this.currentItemType.copyTo(itemType);

      if(isNullOrWhitespace(this.currentItemId)) {
        await this.api.itemTypes.create(itemType);
      } else {
        await this.api.itemTypes.update(itemType, this.currentItemId);
      }
      this.refresh();
      this.editDialog.close();
    });
  }

}