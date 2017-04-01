import 'package:version/version.dart';

abstract class ATemplatingData {
  // We set the default version to the lowest possible value, so that template versions will always appear as more recent.
  Version version = new Version(0,0,1, preRelease: ["alpha"]);
}