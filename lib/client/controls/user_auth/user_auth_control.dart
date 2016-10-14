// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

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

import 'package:dartalog/tools.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_source;

@PolymerRegister('user-auth-control')
class UserAuthControl extends AControl {
  static final Logger _log = new Logger("UserAuthControl");

  @property String userIdValue = "";
  @property String passwordValue = "";
  @property String errorMessage = "";

  UserAuthControl.created() : super.created();

  Completer<bool> _toComplete;

  void reset() {
    set("userIdValue","");
    set("passwordValue","");
    set("errorMessage","");
  }
  void activateDialog({Completer<bool> toComplete}) {
    try {
      _toComplete = toComplete;
      PaperDialog dialog = $['loginDialog'];
      dialog.open();
      focusPaperInput(this.querySelector("#userNameInput"));
    } catch(e, st) {
      _log.severe("activateDialog", e, st);
      handleException(e,st);
    }
  }

  @reflectable
  Future keypress(event, [_]) async {
    if (event.original.charCode == 13) {
      Element ele = getParentElement(event.target, "paper-input");
      switch(ele.id) {
        case "userNameInput":
          focusPaperInput(this.querySelector("#passwordInput"));
          break;
        case "passwordInput":
          logInClicked(null);
          break;
      }
    }
  }

  void cancelClicked(event, [_]) {
    PaperDialog dialog = $['loginDialog'];
    dialog.close();
    this.reset();
    if(this._toComplete!=null)
      this._toComplete.complete(false);
  }

  @reflectable
  logInClicked(event, [_]) async {
    set("errorMessage", "");
    HttpRequest request;
    try {
      String url = "${getServerRoot()}login/";
      var values = {"username": userIdValue, "password": passwordValue};
      request = await HttpRequest.postFormData(
          url, values
      );
      if (!request.responseHeaders.containsKey(HttpHeaders.AUTHORIZATION))
        throw new Exception("Response did not include Authorization header");

      String auth = request.responseHeaders[HttpHeaders.AUTHORIZATION];
      if (isNullOrWhitespace(auth))
        throw new Exception("Auth request did not return a key");

      await data_source.settings.cacheAuthKey(auth);
      PaperDialog dialog = $['loginDialog'];
      dialog.close();

      this.reset();

      if(this._toComplete!=null)
        this._toComplete.complete(true);


      this.evaluateAuthentication();
    } on Exception catch(e,st) {
      set("errorMessage", e.toString());
      _log.severe("logInClicked", e, st);
    } catch(e) {
      request = e.target;
      window.alert(e.runtimeType.toString());
      if(request!=null) {
        String message;
        switch(request.status) {
        case 401:
          message = "Login incorrect";
          break;
        default:
          message = "${request.status} - ${request.statusText} - ${request.responseText}";
          break;
      }
      set("errorMessage", message);

      } else {
        set("errorMessage", "Unknown error while authenticating");
      }
    }
  }

}