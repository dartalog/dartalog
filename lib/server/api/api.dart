import 'package:rpc/rpc.dart';
export 'src/exceptions/redirecting_exception.dart';
export 'src/a_id_resource.dart';
export 'src/a_resource.dart';
export 'src/responses/id_response.dart';
export 'src/responses/paginated_response.dart';

const String API_SETUP_PATH = "setup";

class ManagementApi {}

List<List<int>> convertFiles(List<MediaMessage> input) {
  final List<List<int>> output = [];
  for (MediaMessage mm in input) {
    output.add(mm.bytes);
  }
  return output;
}
