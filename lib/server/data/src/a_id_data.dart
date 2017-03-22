import 'a_data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
export 'a_data.dart';


abstract class AIdData extends AData {
  String get getId;
  set setId(String value);

  String get getName;
  set setName(String value);

  String get getReadableId =>  getId.toString();
  set setReadableId(String value) {  }
}
