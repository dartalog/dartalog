import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:dartalog/services/services.dart';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';

@Component(
    selector: 'auth-status',
    styleUrls: const ['../shared.css'],
    template:
        '<div *ngIf="showMessage&&!authorized" class="no-items">Access Denied</div>')
class AuthStatusComponent implements OnInit, OnDestroy {
  static final Logger _log = new Logger("AuthStatusComponent");

  @Input()
  bool showMessage = false;

  @Input()
  String required = UserPrivilege.patron;

  @Output()
  EventEmitter<bool> authorizedChanged = new EventEmitter<bool>();

  final AuthenticationService _auth;

  StreamSubscription<bool> _subscription;

  AuthStatusComponent(this._auth) {
    _subscription = _auth.authStatusChanged.listen(onAuthStatusChange);
  }

  void onAuthStatusChange(bool status) {
    authorizedChanged.emit(authorized);
  }

  bool get authorized {
    if (!_auth.isAuthenticated) return false;
    return _auth.hasPrivilege(required);
  }

  @override
  void ngOnInit() {
    authorizedChanged.emit(authorized);
  }

  @override
  void ngOnDestroy() {
    _subscription.cancel();
  }
}
