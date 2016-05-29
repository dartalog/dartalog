import 'dart:io';
import 'package:path/path.dart' show join, dirname;

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart' as serverLogging;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_route/shelf_route.dart';
import 'package:shelf_rpc/shelf_rpc.dart' as shelf_rpc;

import 'package:rpc/rpc.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:options_file/options_file.dart';

import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/model/model.dart' as model;

const String _API_PREFIX = '/api';
final ApiServer _apiServer = new ApiServer(apiPrefix: _API_PREFIX, prettyPrint: true);
final Logger _log = new Logger('main');

main(List<String> args) async {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  // Add a simple log handler to log information to a server side file.
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new serverLogging.LogPrintHandler());
  try {
    var pathToBuild = join(ROOT_DIRECTORY, 'web');

    final staticSiteHandler = createStaticHandler(pathToBuild,
        listDirectories: false ,
        defaultDocument: 'index.html',
        serveFilesOutsidePath: true);

    pathToBuild = join(ROOT_DIRECTORY, 'images');

    final staticImagesHandler = createStaticHandler(pathToBuild,
        listDirectories: false ,
        serveFilesOutsidePath: false);


    _apiServer.addApi(new DartalogApi());
    _apiServer.enableDiscoveryApi();

    final api_handler = shelf_rpc.createRpcHandler(_apiServer);

    final root = router()
      ..add("/images/", ['GET','OPTIONS'],staticImagesHandler, exactMatch: false)
      ..add('/api/', ['GET','PUT','POST','HEAD','OPTIONS','DELETE'], api_handler, exactMatch: false)
      ..add('/', ['GET','OPTIONS'], staticSiteHandler, exactMatch: false);

    final HttpServer server = await io.serve(root.handler, 'localhost', model.options.getInt("port"));

    SERVER_ROOT = "http://${server.address.host}:${server.port}/";
    SERVER_API_ROOT = "${SERVER_ROOT}api/dartalog/0.1/";
    print('Serving at ${SERVER_ROOT}');
  } catch(e,s) {
    _log.severe("Error while starting server",e,s);
  }
}
