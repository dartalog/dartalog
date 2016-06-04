// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('user_auth_control.html')
library dartalog.client.controls.user_auth_control;

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

  Completer<bool> _toComplete;

  void activateDialog({Completer<bool> toComplete}) {
    try {
      _toComplete = toComplete;
      PaperDialog dialog = $['loginDialog'];
      dialog.open();
    } catch(e, st) {
      _log.severe("activateDialog", e, st);
      handleException(e,st);
    }
  }

  void cancelClicked(event, [_]) {
    PaperDialog dialog = $['loginDialog'];
    dialog.close();
    if(this._toComplete!=null)
      this._toComplete.complete(false);
  }

  @reflectable
  logInClicked(event, [_]) async {
    set("errorMessage", "");
    HttpRequest request;
    try {
      String url = "${SERVER_ADDRESS}login/";
      var values = {"username": userIdValue, "password": passwordValue};
      request = await HttpRequest.postFormData(
          url, values
      );
      window.alert(request.responseHeaders.keys.join(","));
      if (!request.responseHeaders.containsKey(HttpHeaders.AUTHORIZATION))
        throw new Exception("Response did not include Authorization header");

      String auth = request.responseHeaders[HttpHeaders.AUTHORIZATION];
      if (isNullOrWhitespace(auth))
        throw new Exception("Auth request did not return a key");
      DartalogHttpClient.setAuthKey(auth);
      cacheAuthKey(auth);
      PaperDialog dialog = $['loginDialog'];
      dialog.close();

      if(this._toComplete!=null)
        this._toComplete.complete(true);

      this.mainApp.evaluateAuthentication();
    } on Exception catch(e,st) {
      set("errorMessage", e.toString());
      _log.severe("logInClicked", e, st);
    } catch(e, st) {
      request = e.target;
      if(request!=null) {
        String message = "${request.status} - ${request.statusText} - ${request.responseText}";
        set("errorMessage", message);
      }
    }
  }

}