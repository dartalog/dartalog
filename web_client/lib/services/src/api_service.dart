import 'dart:async';

import 'package:dartalog_shared/global.dart';
import 'package:dartalog/client.dart';
import 'package:dartalog/api/api.dart';

import 'package:angular2/core.dart';
import 'settings_service.dart';

export 'package:dartalog/api/api.dart'
    show PaginatedResponse, ListOfIdNamePair, IdNamePair;

@Injectable()
class ApiService extends ItemApi {
  final SettingsService _settings;
  ApiService(this._settings)
      : super(new ApiHttpClient(_settings),
            rootUrl: getServerRoot(), servicePath: itemApiPath);
}
