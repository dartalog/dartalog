import 'a_data.dart';
export 'a_data.dart';

abstract class AIdData extends AData {
  String get getId;
  set setId(String value);
  String get getName;
  set setName(String value);
}
