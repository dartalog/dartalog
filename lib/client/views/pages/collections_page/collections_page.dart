import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/common_controls.dart';
import 'package:logging/logging.dart';

import '../src/a_maintenance_page.dart';

@Component(
    selector: 'collections-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css", "collections_page.css"],
    templateUrl: 'collections_page.html')
class CollectionsPage extends AMaintenancePage<api.Collection> {
  static final Logger _log = new Logger("CollectionsPage");

  api.IdNamePair selectedUser;

  List<IdNamePair> users = <IdNamePair>[];

  CollectionsPage(PageControlService pageControl, ApiService api,
      AuthenticationService auth, Router router)
      : super(false, pageControl, api, auth, router) {
    pageControl.setPageTitle("Collections");
  }
  @override
  dynamic get itemApi => this.api.collections;

  @override
  Logger get loggerImpl => _log;

  void addBrowser() {
    if (selectedUser != null && this.model != null) {
      if (this.model.browserUuids == null) this.model.browserUuids = <String>[];
      if (!this.model.browserUuids.contains(selectedUser.uuid)) {
        this.model.browserUuids.add(selectedUser.uuid);
      }
    }
  }

  void addCurator() {
    if (selectedUser != null && this.model != null) {
      if (this.model.curatorUuids == null) this.model.curatorUuids = <String>[];
      if (!this.model.curatorUuids.contains(selectedUser.uuid)) {
        this.model.curatorUuids.add(selectedUser.uuid);
      }
    }
  }

  @override
  api.Collection createBlank() {
    final api.Collection model = new api.Collection();
    model.curatorUuids = <String>[];
    model.browserUuids = <String>[];
    return model;
  }

  void removeBrowser(String userUuid) {
    if (model != null && model.browserUuids.contains(userUuid)) {
      model.browserUuids.remove(userUuid);
    }
  }

  void removeCurator(String userUuid) {
    if (model != null && model.curatorUuids.contains(userUuid)) {
      model.curatorUuids.remove(userUuid);
    }
  }

  @override
  void reset() {
    super.reset();
    selectedUser = null;
  }

  @override
  Future<Null> selectItemInternal(IdNamePair item) async {
    users = await this.api.users.getAllIdsAndNames();
  }
}
