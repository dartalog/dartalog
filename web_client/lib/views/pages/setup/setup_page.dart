import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/routes.dart';
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/auth_status_component.dart';
import 'package:dartalog/views/controls/error_output.dart';
import 'package:logging/logging.dart';
import '../src/a_page.dart';

@Component(
    selector: 'setup-page',
    providers: const <dynamic>[materialProviders],
    directives: const <dynamic>[
      materialDirectives,
      ROUTER_DIRECTIVES,
      AuthStatusComponent,
      ErrorOutputComponent
    ],
    styleUrls: const <String>["../../shared.css"],
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
        //final SetupResponse response =
        await _api.setup.get();
      } on DetailedApiRequestError catch (e, st) {
        loggerImpl.warning(e, st);
        if (e.status == 403) {
          // This indicates that setup is disabled, so we redirect to the main page and prompt for login
          await _router.navigate(<String>[homeRoute.name]);
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
      if (request.adminPassword != confirmPassword) {
        final AbstractControl control = form.controls["confirmPassword"];
        control.setErrors(
            <String, String>{"confirmPassword": "Passwords must match"});
        return;
      }
      await performApiCall(() async {
        try {
          //final SetupResponse response =
          await _api.setup.apply(request);
          await refresh();
        } on DetailedApiRequestError catch (e, st) {
          loggerImpl.warning(e, st);
          if (e.status == 403) {
            // This indicates that setup is disabled, so we redirect to the main page and prompt for login
            await _router.navigate(<String>[homeRoute.name]);
            _auth.promptForAuthentication();
          } else {
            rethrow;
          }
        }
      }, form:  form);
    } catch (e, st) {
      setErrorMessage(e, st);
    }
  }

  void clear() {
    request = new SetupRequest();
    confirmPassword = "";
  }
}
