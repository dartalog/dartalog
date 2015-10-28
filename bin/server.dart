import 'dart:io';

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:rpc/rpc.dart';
import 'package:options_file/options_file.dart';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/model/model.dart';

const String _API_PREFIX = '/api';
final ApiServer _apiServer = new ApiServer(apiPrefix: _API_PREFIX, prettyPrint: true);
final Logger _log = new Logger('main');

main() async {
  // Add a simple log handler to log information to a server side file.
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogPrintHandler());
  try {

    OptionsFile options = new OptionsFile('dartalog.options');
    Model.options = options;

    _apiServer.addApi(new DartalogApi());
    _apiServer.enableDiscoveryApi();

    HttpServer server = await HttpServer.bind(InternetAddress.ANY_IP_V4, options.getInt("rpc_port"));
    server.listen(_apiServer.httpRequestHandler);
  } catch(e,s) {
    _log.severe("Error while starting server",e,s);
  }
}