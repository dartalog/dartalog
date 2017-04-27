import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dartalog/api/api.dart' as api;
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/common_controls.dart';
import 'package:dartalog_shared/global.dart';
import 'package:logging/logging.dart';

import '../src/a_maintenance_page.dart';

@Component(
    selector: 'fields-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'fields_page.html')
class FieldsPage extends AMaintenancePage<api.Field> {
  static final Logger _log = new Logger("FieldsPage");

  FieldsPage(PageControlService pageControl, ApiService api,
      AuthenticationService auth, Router router)
      : super("Field", true, pageControl, api, auth, router) {
    pageControl.setPageTitle("Fields");
  }

  Map<String, String> get fieldTypes => globalFieldTypes;

  @override
  dynamic get itemApi => this.api.fields;

  @override
  Logger get loggerImpl => _log;

  @override
  api.Field createBlank() => new api.Field();
}
