import 'dart:html';
import 'package:dartalog/dartalog.dart';
import 'api/dartalog.dart';
import 'src/dartalog_http_client.dart';
export 'api/dartalog.dart' show DartalogApi;
export 'src/http_headers.dart';

final DartalogApi GLOBAL_API = new DartalogApi(new DartalogHttpClient(),
    rootUrl: getServerRoot(), servicePath: API_PATH);

Element getChildElement(Element start, String tagName) {
  if (start == null) return null;
  if (start.tagName == tagName) return start;
  if (start.parent == null) return null;

  for (Element child in start.children) {
    if (child.tagName.toLowerCase() == tagName.toLowerCase()) return child;
  }
  for (Element child in start.children) {
    Element candidate = getChildElement(child, tagName);
    if (candidate != null) return candidate;
  }
  return null;
}

String getImageUrl(String image, ImageType type) {
  if (!image.startsWith(HOSTED_IMAGE_PREFIX)) return image;

  switch (type) {
    case ImageType.ORIGINAL:
      return "${getServerRoot()}${HOSTED_IMAGES_ORIGINALS_PATH}${image
          .substring(HOSTED_IMAGE_PREFIX.length)}";
    case ImageType.THUMBNAIL:
      return "${getServerRoot()}${HOSTED_IMAGES_THUMBNAILS_PATH}${image
          .substring(HOSTED_IMAGE_PREFIX.length)}";
    default:
      throw new Exception("Not supported: ${type}");
  }
}

Element getParentElement(Element start, String tagName) {
  if (start == null) return null;
  if (start.tagName.toLowerCase() == tagName.toLowerCase()) return start;
  if (start.parent == null) return null;

  Element ele = start.parent;
  while (ele != null) {
    if (ele.tagName.toLowerCase() == tagName.toLowerCase()) return ele;
    ele = ele.parent;
  }
  return null;
}

String getServerRoot() {
  StringBuffer output = new StringBuffer();
  output.write(window.location.protocol);
  output.write("//");
  output.write(window.location.host);
  output.write("/");

  // When running in dev, since I use PHPStorm, the client runs via a different
  // server than the dartalog server component. This is usually on a 5-digit port,
  // which theoretically wouldn't be used ina  real deployment.
  // TODO: Figure out a cleaner way of handling this
  if (window.location.port.length >= 5) return "http://localhost:3278/";

  return output.toString();
}

enum ImageType { ORIGINAL, THUMBNAIL }

class ValidationException implements Exception {
  String message;

  ValidationException(this.message);
}
