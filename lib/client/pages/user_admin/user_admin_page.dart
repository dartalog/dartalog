// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('user_admin_page.html')
library dartalog.client.pages.user_admin_page;

import 'dart:async';

import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/combo_list/combo_list_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';

@PolymerRegister('user-admin-page')
class UserAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("UserAdminPage");
  @property
  bool creating = false;

  @property
  List<IdNamePair> items = new List<IdNamePair>();

  @property
  String currentId = "";

  @property
  User currentItem = new User();

  /// Constructor used to create instance of MainApp.
  UserAdminPage.created() : super.created("Users");

  PaperDialog get editDialog =>  this.querySelector('#editDialog');

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");

  @override
  void setGeneralErrorMessage(String message) => set("errorMessage", message);
  @Property(notify:true)
  String errorMessage = "";


  Logger get loggerImpl => _log;

  @Property(notify: true)
  Iterable get userTypes {
    List output = [];
    for (String privilege in dartalog.UserPrivilege.values) {
      output.add(new IdNamePair(privilege, privilege));
    }
    return output;
  }

  attached() {
    super.attached();
    refresh();
  }



  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel(event);
    this.reset();
  }

  @reflectable
  itemClicked(event, [_]) async {
    await handleApiExceptions(() async {
      clearValidation();
      set("creating", false);
      String id = getParentElement(event.target,"paper-item").dataset["id"];
      if (id == null) return;

      API.User user = await api.users.getById(id);

      if (user == null) throw new Exception("Selected user not found");

      currentId = id;

      set("currentItem", new User.copy(user));

      openDialog(editDialog);
    });
  }

  @override
  Future newItem() async {
    set("creating", true);
    try {
      this.reset();
      openDialog(editDialog);
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e, st);
    }
  }

  @reflectable
  Future refresh() async {
    await handleApiExceptions(() async {
      try {
        this.startLoading();

        bool authed = await authWrapper.evaluatePageAuthentication();
        this.showRefreshButton = authed;
        this.showAddButton = authed;
        if(!authed)
          return;

        this.reset();
        clear("items");

        API.ListOfIdNamePair data = await api.users.getAllIdsAndNames();

        for (API.IdNamePair pair in data) {
          add("items", new IdNamePair.copy(pair));
        }
      } finally {
        this.stopLoading();
        this.evaluatePage();
      }
    });
  }

  @reflectable
  void reset() {
    clearValidation();
    currentId = "";
    set('currentItem', new User());
  }

  @reflectable
  saveClicked(event, [_]) async {
    if (currentItem.password != currentItem.confirmPassword) {
      setFieldMessage("confirmPassword", "Doesn't match");
      return;
    }
    await handleApiExceptions(() async {
      API.User user = new API.User();
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

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
  }

  @reflectable
  validateField(event, [_]) {
    _log.info("Validating");
  }
}
