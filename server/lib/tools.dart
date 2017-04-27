import 'package:rpc/rpc.dart';

List<List<int>> convertMediaMessagesToIntLists(List<MediaMessage> input) {
  final List<List<int>> output = <List<int>>[];
  for (MediaMessage mm in input) {
    output.add(mm.bytes);
  }
  return output;
}

/// Performs clean-up techniques on readable IDs that have been received via the API.
///
/// Performs URI decoding, trims, and toLowerCases the string to ensure consistent readable ID formatting and matching.
String normalizeReadableId(String input) {
  if(input==null)
    throw new ArgumentError.notNull("input");

  String output = Uri.decodeQueryComponent(input);
  output = output.trim().toLowerCase();

  return output;
}