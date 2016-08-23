// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('collections_page.html')
library dartalog.client.pages.collections_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_input.dart';
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
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('collections-page')
class CollectionsPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("CollectionsPage");
  Logger get loggerImpl => _log;

  @property
  List<IdNamePair> collections = new List<IdNamePair>();

  @property
  List<IdNamePair> users = new List<IdNamePair>();

  String currentId = "";
  @property Collection currentCollection = new Collection();

  PaperDialog get editDialog =>  this.querySelector('#editDialog');

  @override
  void setGeneralErrorMessage(String message) => set("errorMessage", message);
  @Property(notify:true)
  String errorMessage = "";

  @property
  bool userHasAccess = false;

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");

  /// Constructor used to create instance of MainApp.
  CollectionsPage.created() : super.created("Collection Maintenance");


  Future activateInternal([bool forceRefresh = false]) async {
    bool authed = authWrapper.evaluateAuthentication();
    if(authed)
      await this.refresh();
    this.showRefreshButton = authed;
    this.showAddButton = authed;
  }

  @reflectable
  Future refresh() async {
    await handleApiExceptions(() async {
      this.reset();
      clear("collections");
      clear("users");

      API.ListOfIdNamePair data = await api.collections.getAllIdsAndNames();

      addAll("collections", IdNamePair.copyList(data));

      data = await api.users.getAllIdsAndNames();

      addAll("users", IdNamePair.copyList(data));
    });
  }


  @reflectable
  void reset() {
    clearValidation();
    currentId = "";
    set('currentCollection', new Collection());
  }

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
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
  collectionClicked(event, [_]) async {
    await handleApiExceptions(() async {
      String id = event.target.dataset["id"];
      if (id == null)
        return;

      API.Collection collection = await api.collections.getById(id);

      if (collection == null)
        throw new Exception("Selected collection not found");

      currentId = id;

      set("currentCollection", new Collection.copy(collection));

      openDialog(editDialog);
    });
  }

  @reflectable
  validateField(event, [_]) {
    _log.info("Validating");
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.close();
    this.reset();
  }

  @reflectable
  saveClicked(event, [_]) async {
    await handleApiExceptions(() async {
      if(currentUser.isEmpty)
        return; // Not signed in, how can you be doing anything?

      if(!currentCollection.curators.contains(currentUser.get().id)&&!window.confirm("Your user is not in the list of curators, are you sure you want to continue?"))
        return;

      API.Collection collection = new API.Collection();
      currentCollection.copyTo(collection);
      if (isNullOrWhitespace(this.currentId)) {
        await this.api.collections.create(collection);
      } else {
        await this.api.collections.update(collection, this.currentId);
      }

      refresh();
      editDialog.close();
      showMessage("Collection saved");
    });
  }

}