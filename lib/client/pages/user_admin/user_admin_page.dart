// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('user_admin_page.html')
library dartalog.client.pages.user_admin_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('user-admin-page')
class UserAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("UserAdminPage");
  Logger get loggerImpl => _log;

  @property
  bool creating = false;

  @property
  List<IdNamePair> items = new List<IdNamePair>();

  @property
  String currentId = "";

  @property
  User currentItem = new User();


  /// Constructor used to create instance of MainApp.
  UserAdminPage.created() : super.created("User Admin");

  PaperDialog get editDialog =>  $['editDialog'];

  Future activateInternal(Map args) async {
    await this.refresh();
  }

  @override
  void clearValidation() {
    $['output_field_error'].text = "";
    super.clearValidation();
  }

  @reflectable
  Future refresh() async {
    await handleApiExceptions(() async {
      this.reset();
      clear("items");

      API.ListOfIdNamePair data = await api.users.getAllIdsAndNames();

      for(API.IdNamePair pair  in data) {
        add("items", new IdNamePair.copy(pair));
      }
    });
  }


  @reflectable
  void reset() {
    clearValidation();
    currentId = "";
    set('currentItem', new User());
  }

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
  }

  @override
  Future newItem() async {
    set("creating", true);
    try {
      this.reset();
      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  itemClicked(event, [_]) async {
    await handleApiExceptions(() async {
      clearValidation();
      set("creating", false );
      String id = event.target.dataset["id"];
      if(id==null)
        return;

      API.User user = await api.users.getById(id);

      if(user==null)
        throw new Exception("Selected user not found");

      set("currentId",id);

      set("currentItem", new User.copy(user));

      editDialog.open();
    });
  }

  @reflectable
  validateField(event, [_]) {
    _log.info("Validating");
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel();
    this.reset();
  }

  @reflectable
  saveClicked(event, [_]) async {
    if(currentItem.password!=currentItem.confirmPassword) {
      setFieldMessage("confirmPassword","Doesn't match");
      return;
    }
    await handleApiExceptions(() async {


      API.User user= new API.User();
      currentItem.copyTo(user);
      if (isNullOrWhitespace(this.currentId)) {
        await this.api.users.create(user);
      } else {
        await this.api.users.update(user, this.currentId);
      }

      refresh();
      editDialog.close();
      showMessage("User saved");
    });
  }

}