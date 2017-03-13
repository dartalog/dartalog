import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'auth-status',
    template: '')
class AuthStatusComponent implements OnDestroy {
  static final Logger _log = new Logger("AuthStatusComponent");


  @Output()
  EventEmitter<bool> authedChanged = new EventEmitter<bool>();

  final AuthenticationService _auth;

  StreamSubscription<bool> _subscription;

  AuthStatusComponent(this._auth) {
    _subscription = _auth.authStatusChanged.listen(onAuthStatusChange);
  }

  void onAuthStatusChange(bool status) {
    authedChanged.emit(status);
  }

  @Input()
  set authed(bool value) {
    return _auth.isAuthenticated;
  }
  bool get authed => _auth.isAuthenticated;


  @override
  void ngOnDestroy() {
    _subscription.cancel();
  }

}
