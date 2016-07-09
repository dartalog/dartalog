// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('auth_wrapper_control.html')
library dartalog.client.controls.auth_wrapper;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/controls/controls.dart';

@PolymerRegister('auth-wrapper-control')
class AuthWrapperControl extends AControl  {
  static final Logger _log = new Logger("AuthWrapperControl");

  Logger get loggerImpl => _log;

  @property
  bool restamp = true;

  @property
  bool userHasAccess = false;

  @Property(notify: true, observer: "evaluateAuthentication")
  String minimumPrivilege = UserPrivilege.admin;

  AuthWrapperControl.created() : super.created();

  bool evaluateAuthentication([_]) {
    set("userHasAccess", this.userHasPrivilege(minimumPrivilege));
    return userHasAccess;
  }

}