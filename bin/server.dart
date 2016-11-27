import 'dart:async';
import 'dart:io';

import 'package:dartalog/global.dart';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_source;
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart'
    as server_logging;
import 'package:option/option.dart';
import 'package:path/path.dart' show join;
import 'package:rpc/rpc.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_auth/shelf_auth.dart';
import 'package:shelf_exception_handler/shelf_exception_handler.dart';
import 'package:shelf_route/shelf_route.dart';
import 'package:shelf_rpc/shelf_rpc.dart' as shelf_rpc;
import 'package:shelf_static/shelf_static.dart';

void main(List<String> args) {
//  var parser = new argsLib.ArgParser()
//    ..addOption('port', abbr: 'p', defaultsTo: '8080');
//
//  var result = parser.parse(args);
//
//  var port = int.parse(result['port'], onError: (val) {
//    stdout.writeln('Could not parse port value "$val" into a number.');
//    exit(1);
//  });
//
  // Add a simple log handler to log information to a server side file.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(new server_logging.LogPrintHandler());

  _startServer();
}

const String _apiPrefix = '/api';

final ApiServer _apiServer =
    new ApiServer(apiPrefix: _apiPrefix, prettyPrint: true);

final Logger _log = new Logger('main');

HttpServer _server;

Future<Option<Principal>> _authenticateUser(
    String userName, String password) async {
  final Option<User> user =
      await data_source.users.getById(userName.trim().toLowerCase());

  if (user.isEmpty) return new None<Principal>();

  final Option<String> hashOption =
      await data_source.users.getPasswordHash(user.get().getId);

  if (hashOption.isEmpty)
    throw new Exception("User does not have a password set");

  if (model.users.verifyPassword(hashOption.get(), password))
    return new Some<Principal>(new Principal(user.get().getId));
  else
    return new None<Principal>();
}

Future<Option<Principal>> _getUser(String userName) async {
  final Option<User> user = await data_source.users.getById(userName);
  if (user.isEmpty) return new None<Principal>();
  return new Some<Principal>(new Principal(user.get().getId));
}

dynamic _startServer() async {
  try {
    if (_server != null)
      throw new Exception("Server has already been instantiated");

    String pathToBuild;

    pathToBuild = join(rootDirectory, 'images');

    final Handler staticImagesHandler = createStaticHandler(pathToBuild,
        listDirectories: false,
        serveFilesOutsidePath: false,
        useHeaderBytesForContentType: true);

    _apiServer.addApi(new ItemApi());
    _apiServer.enableDiscoveryApi();

    final JwtSessionHandler<Principal, SessionClaimSet> sessionHandler =
        new JwtSessionHandler<Principal, SessionClaimSet>(
            'dartalog', 'shhh secret', _getUser,
            idleTimeout: new Duration(hours: 1),
            totalSessionTimeout: new Duration(days: 7));

    final Middleware loginMiddleware = authenticate(<Authenticator<Principal>>[
      new UsernamePasswordAuthenticator<Principal>(_authenticateUser)
    ], sessionHandler: sessionHandler, allowHttp: true);

    final Middleware defaultAuthMiddleware = authenticate(
        <Authenticator<Principal>>[],
        sessionHandler: sessionHandler,
        allowHttp: true,
        allowAnonymousAccess: true);

    final Handler loginPipeline = const Pipeline()
        .addMiddleware(loginMiddleware)
        .addHandler((Request request) => new Response.ok(""));

    final Handler apiHandler = shelf_rpc.createRpcHandler(_apiServer);
    final Handler apiPipeline = const Pipeline()
        .addMiddleware(defaultAuthMiddleware)
        .addHandler(apiHandler);

    final Router<dynamic> root = router()
      ..add('/login/', <String>['POST', 'GET', 'OPTIONS'], loginPipeline)
      ..add("/images/", <String>['GET', 'OPTIONS'], staticImagesHandler,
          exactMatch: false)
      ..add(
          '/api/',
          <String>['GET', 'PUT', 'POST', 'HEAD', 'OPTIONS', 'DELETE'],
          apiPipeline,
          exactMatch: false);



    pathToBuild = join(rootDirectory, 'build/web/');
    Directory siteDir = new Directory(pathToBuild);
    if(siteDir.existsSync()) {
      final staticSiteHandler = createStaticHandler(pathToBuild,
          listDirectories: false,
          defaultDocument: 'index.html',
          serveFilesOutsidePath: true);
      root.add('/', ['GET', 'OPTIONS'], staticSiteHandler, exactMatch: false);
    }

    final Map<String, String> extraHeaders = <String, String>{
      'Access-Control-Allow-Headers':
          'Origin, X-Requested-With, Content-Type, Accept, Authorization',
      'Access-Control-Allow-Methods': 'POST, GET, PUT, HEAD, DELETE, OPTIONS',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Expose-Headers': 'Authorization',
      'Access-Control-Allow-Origin': '*'
    };
    Response _cors(Response response) => response.change(headers: extraHeaders);
    final Middleware _fixCORS = createMiddleware(responseHandler: _cors);

    final Handler handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_fixCORS)
        .addMiddleware(exceptionHandler())
        .addHandler(root.handler);

    _server = await io.serve(
        handler, model.settings.serverBindToAddress, model.settings.serverPort);

    serverRoot = "http://${_server.address.host}:${_server.port}/";
    serverApiRoot = "$serverRoot$itemApiPath";
    print('Serving at $serverRoot');
  } catch (e, s) {
    _log.severe("Error while starting server", e, s);
  }
}

dynamic _stopServer() async {
  if (_server == null) throw new Exception("Server has not been started");
  await _server.close();
  _server = null;
}
