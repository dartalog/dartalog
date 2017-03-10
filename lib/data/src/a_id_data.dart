import 'a_data.dart';
export 'a_data.dart';

abstract class AIdData extends AData {
  String get getId;
  set getId(String value);
  String get getName;
  set getName(String value);
}
