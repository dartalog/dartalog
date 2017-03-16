import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/tools.dart';
@Component(
    selector: 'login-form',
    styleUrls: const ["../shared.css"],
    directives: const [materialDirectives],
    providers: const [materialProviders],
    template: '''<modal [visible]="visible">
      <material-dialog class="basic-dialog">
          <h3 header>Login</h3>
            <form (ngSubmit)="onSubmit()" #loginForm="ngForm">
            <p>
              <material-input [(ngModel)]="userName" ngControl="userName" floatingLabel required  autoFocus label="User">material-input></material-input><br/>
              <material-input [(ngModel)]="password" ngControl="password" floatingLabel required  label="Password" type="password"></material-input><br/>
              <input type="submit" style="position: absolute; left: -9999px; width: 1px; height: 1px;"/>
                <span *ngIf="hasErrorMessage" class="error_output">
                    <glyph icon="error_outline"></glyph>
                    {{errorMessage}}
                </span>
          </p>
            </form>
          <div footer style="text-align: right">
            <material-yes-no-buttons yesHighlighted
            yesText="Login" (yes)="onSubmit()"
            noText="Cancel" (no)="visible = false"
            [pending]="processing" [yesDisabled]="!loginForm.valid">
            </material-yes-no-buttons>

          </div>
      </material-dialog>
    </modal>''')
class LoginFormComponent {
  static final Logger _log = new Logger("UserAuthComponent");
  String userName = "";
  String password = "";

  bool get hasErrorMessage => StringTools.isNotNullOrWhitespace(errorMessage);
  String errorMessage = "";

  bool _visible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  final AuthenticationService _auth;

  LoginFormComponent(this._auth);

  bool processing = false;

  bool get visible => _visible;

  @Input()
  set visible(bool value) {
    reset();
    if(value) {
      processing = false;
    }
    _visible = value;
    visibleChange.emit(_visible);
  }

  Future<Null> onSubmit() async {
    errorMessage = "";
    processing = true;
    try {
      await _auth.authenticate(userName,password);
      visible = false;
    } on Exception catch (e, st) {
      errorMessage = e.toString();
      _log.severe("logInClicked", e, st);
    } catch (e) {
      final HttpRequest request = e.target;
      if (request != null) {
        String message;
        switch (request.status) {
          case 401:
            message = "Login incorrect";
            break;
          default:
            message =
            "${request.status} - ${request.statusText} - ${request
                .responseText}";
            break;
        }
        errorMessage = message;
      } else {
        errorMessage = "Unknown error while authenticating";
      }
    } finally {
      processing = false;
    }
  }

  void reset() {
    userName = "";
    password = "";
    errorMessage = "";
  }
}
