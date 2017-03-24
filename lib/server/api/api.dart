import 'package:rpc/rpc.dart';
export 'src/exceptions/redirecting_exception.dart';
export 'src/a_id_resource.dart';
export 'src/a_resource.dart';
export 'src/responses/id_response.dart';
export 'src/responses/paginated_response.dart';

export 'item/src/requests/setup_request.dart';
export 'item/src/responses/setup_response.dart';

const String setupApiPath = "setup";

class ManagementApi {}

List<List<int>> convertFiles(List<MediaMessage> input) {
  final List<List<int>> output = [];
  for (MediaMessage mm in input) {
    output.add(mm.bytes);
  }
  return output;
}
