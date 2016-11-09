// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('user_picker_control.html')
library dartalog.client.controls.combo_list;


import 'package:dartalog/client/data/data.dart';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_tooltip.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/client.dart';
import 'dart:html';
import 'package:dartalog/client/api/api.dart' as API;

@PolymerRegister('user-picker-control')
class UserPickerControl extends AControl {
  static final Logger _log = new Logger("UserPickerControl");

  Logger get loggerImpl => _log;

  @property
  String errorMessage = "";

  @property
  bool invalid = false;

  @property
  String label = "";

  @property
  List<IdNamePair> items = [];

  @property
  List selectedItems = [];

  @property
  List<String> selectedValues = [];

  @Property(notify: true)
  String selectedItem;

  UserPickerControl.created() : super.created();

  attached() {
    getItems();
  }

  Future<Null> refresh() async {
    await getItems();
  }

  Future getItems() async {
    await handleApiExceptions(() async {
      clear("items");
      API.ListOfIdNamePair users = await API.item.users.getAllIdsAndNames();
      addAll("items", IdNamePair.copyList(users));
    });
  }

  setInvalid(bool value) {
    set("invalid", value);
  }

  @override
  setGeneralErrorMessage(String value) {
    set("errorMessage", value);
  }

}
