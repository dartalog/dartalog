import 'package:rpc/rpc.dart';
import 'package:dartalog/server/api/resources/resources.dart';

@ApiClass(version: '0.1', name: 'dartalog', description: 'Dartalog REST API')
class DartalogApi {
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
  final SetupResource setup = new SetupResource();

  DartalogApi();
}
