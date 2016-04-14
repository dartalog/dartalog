import 'dart:io';
import 'package:path/path.dart' show join, dirname;

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_rpc/shelf_rpc.dart' as shelf_rpc;

import 'package:rpc/rpc.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:options_file/options_file.dart';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/model/model.dart';

const String _API_PREFIX = '/api';
final ApiServer _apiServer = new ApiServer(apiPrefix: _API_PREFIX, prettyPrint: true);
final Logger _log = new Logger('main');

main() async {
  Chain.capture(() async {
  // Add a simple log handler to log information to a server side file.
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogPrintHandler());
  try {
    var pathToBuild = join(dirname(Platform.script.toFilePath()),
        '..', 'web');

    var static_handler = createStaticHandler(pathToBuild,
        defaultDocument: 'index.html',
        serveFilesOutsidePath: true);

    _apiServer.addApi(new DartalogApi());
    var api_handler = shelf_rpc.createRpcHandler(_apiServer);
    io.serve(api_handler, 'localhost',  Model.options.getInt("rpc_port"));

    var handler = new shelf.Cascade()
        .add(static_handler)
        .add(api_handler)
        .handler;

    io.serve(handler, 'localhost', Model.options.getInt("port")).then((server) {
      print('Serving at http://${server.address.host}:${server.port}');
    });
  } catch(e,s) {
    _log.severe("Error while starting server",e,s);
  }
  });
}

shelf.Response _echoRequest(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}