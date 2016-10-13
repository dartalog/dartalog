import '../config.dart';

abstract class AItem {
  Map data;
  Config config;
  AItem(this.data, this.config);
}