import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/routes.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/auth_status_component.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/client/routes.dart';
import 'package:dartalog/global.dart';
import '../src/a_page.dart';
import 'package:angular2/router.dart';
@Component(
    selector: 'setup-page',
    providers: const [materialProviders],
    directives: const [
      materialDirectives,
      ROUTER_DIRECTIVES,
      AuthStatusComponent,
    ],
    styleUrls: const ["../../shared.css"],
    templateUrl: "setup_page.html")
class SetupPage extends APage implements OnInit {
  static final Logger _log = new Logger("SetupPage");

  @ViewChild("setupForm")
  NgForm form;

  SetupResponse status = new SetupResponse();
  SetupRequest request = new SetupRequest();
  String confirmPassword = "";

  PageControlService _pageControl;
  ApiService _api;
  Router _router;
  AuthenticationService _auth;

  SetupPage(this._pageControl, this._api, this._auth, this._router)
      : super(_pageControl, _auth, _router) {
    _pageControl.setPageTitle("Setup");
  }

  @override
  Logger get loggerImpl => _log;


  @override
  void ngOnInit() {
    refresh();
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      try {
        SetupResponse response = await _api.setup.get();
      } on DetailedApiRequestError catch (e, st) {
        if(e.status==403) {
          // This indicates that setup is disabled, so we redirect to the main page and prompt for login
          await _router.navigate(homeRoute.name);
          _auth.promptForAuthentication();
        } else {
          rethrow;
        }
      }
    });
  }

  Future<Null> onSubmit() async {
    try {
      // TODO: Figure out how to use angular's validators to do this on-the-fly
      if(request.adminPassword!=confirmPassword) {
        final AbstractControl control = form.controls["confirmPassword"];
        control.setErrors({"confirmPassword": "Passwords must match"});
        return;
      }
      await performApiCall(() async {
        try {
          SetupResponse response = await _api.setup.apply(request);
          await refresh();
        } on DetailedApiRequestError catch (e, st) {
          if(e.status==403) {
            // This indicates that setup is disabled, so we redirect to the main page and prompt for login
            await _router.navigate(homeRoute.name);
            _auth.promptForAuthentication();
          } else {
            rethrow;
          }
        }
      });

    } catch(e,st) {
      errorMessage = e.toString();
    }
  }

  void clear() {
    request = new SetupRequest();
    confirmPassword = "";
  }
}