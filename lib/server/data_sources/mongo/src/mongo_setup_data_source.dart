import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_data_source.dart';
import 'a_mongo_id_data_source.dart';

class MongoSetupDataSource extends AMongoDataSource with ASetupDataSource {
  static final Logger _log = new Logger('MongoSetupDataSource');

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getSetupCollection();

  Future<bool> isSetup() async {
    dynamic selector = where.eq(ID_FIELD, "setup");
    dynamic output = await this.genericFind(selector);
    if(output==null)
      return false;
  }

  Future markAsSetup() async {
    dynamic selector = where.eq(ID_FIELD, "setup");
    await this.deleteFromDb(selector);
  }


  Future<String> getVersion() async => "1.0";
  Future setVersion(String version) {}
}
