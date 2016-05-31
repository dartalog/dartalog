// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
library dartalog.client.controls.user_auth_control;
@HtmlImport('user_auth_control.html')

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_dialog.dart';

import 'package:dartalog/tools.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';

@PolymerRegister('user-auth-control')
class UserAuthControl extends AControl {
  static final Logger _log = new Logger("UserAuthControl");

  @property String userIdValue = "";
  @property String passwordValue = "";
  @property String errorMessage = "";

  UserAuthControl.created() : super.created();

  void activateDialog() {
    try {
      PaperDialog dialog = $['loginDialog'];
      dialog.open();
    } catch(e, st) {
      _log.severe("activateDialog", e, st);
      handleException(e,st);
    }
  }

  @reflectable
  logInClicked(event, [_]) async {
    set("errorMessage", "");
    try {
      HttpRequest request = await HttpRequest.postFormData(
          "${SERVER_ADDRESS}login/",
          {"username": userIdValue, "password": passwordValue});
      String auth = request.getResponseHeader("Authorization");
      if(isNullOrWhitespace(auth))
        throw new Exception("Auth request did not return a key");
      cacheAuthKey(auth);
      window.alert(auth);
    } catch(e, st) {
      set("errorMessage", e.toString());
      _log.severe("logInClicked", e, st);
      handleException(e,st);
    }
  }

}