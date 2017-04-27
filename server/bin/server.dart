import 'dart:io';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart'
    as server_logging;
import 'package:options_file/options_file.dart';

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
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen(new server_logging.LogPrintHandler());
  final Logger _log = new Logger("server.main()");

  String connectionString = "mongodb://localhost:27017/dartalog";
  String ip = InternetAddress.LOOPBACK_IP_V6.address;
  int port = 3278;

  try {
    final OptionsFile optionsFile = new OptionsFile('server.options');
    connectionString = optionsFile.getString("connection_string",connectionString);
    port = optionsFile.getInt("port",port);
    ip = optionsFile.getString("bind",ip);
  } on FileSystemException catch (e) {
    _log.info("server.options not found, using all default settings", e);
  }


  final Server server = Server.createInstance(connectionString);
  server.start(ip, port);
}




