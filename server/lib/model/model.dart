import 'package:dartalog_shared/tools.dart';
import 'package:di/di.dart';
import 'src/field_model.dart';
import 'src/user_model.dart';
import 'src/setup_model.dart';
//import 'src/settings_model.dart';
import 'src/item_model.dart';
import 'src/import_model.dart';
import 'src/collections_model.dart';
import 'src/item_type_model.dart';
import 'src/export_model.dart';
import 'src/item_copy_model.dart';
import 'package:dartalog/data_sources/data_sources.dart';

export 'src/a_id_name_based_model.dart';
export 'src/item_type_model.dart';
export 'src/a_uuid_based_model.dart';
export 'src/a_file_upload_model.dart';
export 'src/a_model.dart';
export 'src/field_model.dart';
export 'src/user_model.dart';
export 'src/setup_model.dart';
//export 'src/settings_model.dart';
export 'src/item_model.dart';
export 'src/import_model.dart';
export 'src/collections_model.dart';
export 'src/item_type_model.dart';
export 'src/export_model.dart';
export 'src/item_copy_model.dart';

ModuleInjector createModelModuleInjector(String connectionString) {
  final Module module = new Module()
    ..bind(UserModel)
    ..bind(FieldModel)
    ..bind(CollectionsModel)
    ..bind(ItemTypeModel)
    ..bind(ItemModel)
    ..bind(ItemCopyModel)
    ..bind(SetupModel)
    ..bind(ImportModel)
    ..bind(ExportModel);
//  if (StringTools.isNotNullOrWhitespace(settingsFile)) {
//    output.bind(SettingsModel,
//        toFactory: () => new SettingsModel.openFile(settingsFile));
//  } else {
//    output.bind(SettingsModel);
//  }

  final ModuleInjector parent = createDataSourceModuleInjector(connectionString);
  return new ModuleInjector([module], parent);
}
