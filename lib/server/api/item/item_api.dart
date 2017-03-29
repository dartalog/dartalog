import 'package:rpc/rpc.dart';
import 'src/resources/field_resource.dart';
import 'src/resources/item_resource.dart';
import 'src/resources/item_type_resource.dart';
import 'src/resources/import_resource.dart';
import 'src/resources/collection_resource.dart';
import 'src/resources/preset_resource.dart';
import 'src/resources/user_resource.dart';
import 'package:dartalog/global.dart';
import 'src/resources/export_resource.dart';
import 'src/resources/setup_resource.dart';

//export 'src/requests/bulk_item_action_request.dart';
//export 'src/requests/item_action_request.dart';
//export 'src/requests/create_item_request.dart';
//export 'src/requests/update_item_request.dart';
//export 'src/requests/transfer_request.dart';

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
  final FieldResource fields = new FieldResource();

  @ApiResource()
  final ItemTypeResource itemTypes = new ItemTypeResource();

  @ApiResource()
  final ItemResource items = new ItemResource();

  @ApiResource()
  final ImportResource import = new ImportResource();

  @ApiResource()
  final PresetResource presets = new PresetResource();

  @ApiResource()
  final CollectionResource collections = new CollectionResource();

  @ApiResource()
  final UserResource users = new UserResource();

  @ApiResource()
  final ExportResource export = new ExportResource();

  @ApiResource()
  final SetupResource setup = new SetupResource();

  ItemApi();
}
