import 'dart:async';

import 'package:dartalog/global.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/api/api.dart';

import 'package:angular2/core.dart';
import 'settings_service.dart';

export 'package:dartalog/client/api/api.dart' show PaginatedResponse;

@Injectable()
class ApiService extends ItemApi {
  final SettingsService _settings;
  ApiService(this._settings): super(new ApiHttpClient(_settings),
        rootUrl: getServerRoot(), servicePath: itemApiPath);

}