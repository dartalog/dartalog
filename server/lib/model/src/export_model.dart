import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/import/import.dart';
import 'a_model.dart';
import 'package:dartalog/data_sources/data_sources.dart' as data_source;
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/data/data.dart';
import 'package:uuid/uuid.dart';
import 'package:dartalog/data_sources/data_sources.dart';

class ExportModel extends AModel {
  static final Logger _log = new Logger('ExportModel');

  final ACollectionDataSource collectionDataSource;

  ExportModel(this.collectionDataSource, AUserDataSource userDataSource): super(userDataSource);

  @override
  Logger get loggerImpl => _log;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.admin;

  // This is a temporary implementation to insert UUIds where there where none before
  void fixIds(AHumanFriendlyData data) {
    if (StringTools.isNullOrWhitespace(data.readableId)) {
      data.readableId = data.uuid;
      data.uuid = generateUuid();
    }
  }

  Future<List<Collection>> exportCollections() async {
    //await validateGetPrivileges();
    final List<Collection> output = await collectionDataSource.getAll();
    for (Collection c in output) {
      fixIds(c);
    }
    return output;
  }
}
