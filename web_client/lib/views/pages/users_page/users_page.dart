import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/api/api.dart' as api;
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/common_controls.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import '../src/a_maintenance_page.dart';
import 'package:dartalog_shared/global.dart';

@Component(
    selector: 'users-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css", "users_page.css"],
    templateUrl: 'users_page.html')
class UsersPage extends AMaintenancePage<api.User> {
  static final Logger _log = new Logger("UsersPage");

  List<String> get userTypes => UserPrivilege.values;

  @ViewChild("changePasswordForm")
  NgForm changePasswordForm;

  String changePassword = "";
  String changePasswordConfirm = "";

  UsersPage(PageControlService pageControl, ApiService api,
      AuthenticationService auth, Router router)
      : super(false, pageControl, api, auth, router) {
    pageControl.setPageTitle("Users");
  }

  void resetChangePassword() {
    changePassword = "";
    changePasswordConfirm = "";
  }

  @override
  dynamic get itemApi => this.api.users;

  @override
  Logger get loggerImpl => _log;

  @override
  api.User createBlank() {
    final api.User model = new api.User();
    return model;
  }

  Future<Null> onSubmitPassword(String userUuid) async {
    await performApiCall(() async {
      if (changePassword != changePasswordConfirm) {
        final AbstractControl control =
            changePasswordForm.controls["changePasswordConfirm"];
        control.setErrors(
            <String, String>{"changePasswordConfirm": "Passwords must match"});
        return;
      }

      final api.PasswordChangeRequest request = new api.PasswordChangeRequest();
      request.newPassword = changePassword;

      await this.api.users.changePassword(request, userUuid);
    });
  }
}
