import 'package:dartalog_shared/global.dart';
import 'package:di/di.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:rpc/rpc.dart';

import 'src/resources/collection_resource.dart';
import 'src/resources/export_resource.dart';
import 'src/resources/field_resource.dart';
import 'src/resources/import_resource.dart';
import 'src/resources/item_resource.dart';
import 'src/resources/item_copy_resource.dart';
import 'src/resources/item_type_resource.dart';
import 'src/resources/preset_resource.dart';
import 'src/resources/setup_resource.dart';
import 'src/resources/user_resource.dart';

export 'src/resources/collection_resource.dart';
export 'src/resources/export_resource.dart';
export 'src/resources/field_resource.dart';
export 'src/resources/import_resource.dart';
export 'src/resources/item_resource.dart';
export 'src/resources/item_type_resource.dart';
export 'src/resources/preset_resource.dart';
export 'src/resources/setup_resource.dart';
export 'src/resources/user_resource.dart';
import 'package:dartalog/model/model.dart';

//export 'src/requests/bulk_item_action_request.dart';
//export 'src/requests/item_action_request.dart';
//export 'src/requests/create_item_request.dart';
//export 'src/requests/update_item_request.dart';
//export 'src/requests/transfer_request.dart';
export 'src/requests/password_change_request.dart';

@ApiClass(
    version: itemApiVersion, name: itemApiName, description: 'Item REST API')
class ItemApi {
  static const String bulkPath = "bulk";
  static const String collectionsPath = "collections";
  static const String copiesPath = "copies";
  static const String fieldsPath = "fields";
  static const String actionsPath = "actions";
  static const String historyPath = "history";
  static const String importPath = "import";
  static const String itemTypesPath = "types";
  static const String itemsPath = "items";
  static const String usersPath = "users";
  static const String exportPath = "export";
  static const String templatesPath = "templates";

  @ApiResource()
  final FieldResource fields;

  @ApiResource()
  final ItemTypeResource itemTypes;

  @ApiResource()
  final ItemResource items;

  @ApiResource()
  final ImportResource import;

  @ApiResource()
  final PresetResource presets;

  @ApiResource()
  final CollectionResource collections;

  @ApiResource()
  final UserResource users;

  @ApiResource()
  final ExportResource export;

  @ApiResource()
  final SetupResource setup;

  ItemApi(this.fields, this.itemTypes, this.items, this.import, this.presets,
      this.collections, this.users, this.export, this.setup);

  static Module get injectorModules => new Module()
    ..bind(FieldResource)
    ..bind(ItemTypeResource)
    ..bind(ItemResource)
    ..bind(ItemCopyResource)
    ..bind(ImportResource)
    ..bind(PresetResource)
    ..bind(CollectionResource)
    ..bind(UserResource)
    ..bind(ExportResource)
    ..bind(SetupResource)
    ..bind(ItemApi);
}
