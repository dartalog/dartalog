library model;

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:crypt/crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:option/option.dart';
import 'package:image/image.dart';
import 'package:options_file/options_file.dart';
import 'package:shelf_auth/shelf_auth.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/import/import.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;

part 'src/a_model.dart';
part 'src/a_typed_model.dart';
part 'src/a_id_name_based_model.dart';
part 'src/field_model.dart';
part 'src/user_model.dart';
part 'src/setup_model.dart';
part 'src/settings_model.dart';
part 'src/item_model.dart';
part 'src/import_model.dart';
part 'src/collections_model.dart';
part 'src/item_type_model.dart';
part 'src/item_copy_model.dart';

final UserModel users = new UserModel();
final FieldModel fields = new FieldModel();
final CollectionsModel collections = new CollectionsModel();
final ItemTypeModel itemTypes = new ItemTypeModel();
final ItemModel items = new ItemModel();
final SetupModel setup = new SetupModel();
final SettingsModel settings = new SettingsModel();
final ImportModel import = new ImportModel();