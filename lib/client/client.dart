import 'dart:html';
import 'package:dartalog/global.dart';
import 'package:option/option.dart';
export 'src/http_headers.dart';

/// Gets the first child [Element] matching the specified name.
Option<Element> getChildElement(Element start, String tagName) {
  if (start == null) return new None<Element>();
  if (start.tagName.toLowerCase() == tagName.toLowerCase())
    return new Some<Element>(start);
  if (start.parent == null) return new None<Element>();

  for (Element child in start.children) {
    if (child.tagName.toLowerCase() == tagName.toLowerCase())
      return new Some<Element>(child);
  }
  for (Element child in start.children) {
    final Option<Element> candidate = getChildElement(child, tagName);
    if (candidate.isNotEmpty) return candidate;
  }
  return new None<Element>();
}

/// Determines the appropriate URL to get an image from the server's image store.
String getImageUrl(String image, ImageType type) {
  if (!image.startsWith(HOSTED_IMAGE_PREFIX)) return image;

  switch (type) {
    case ImageType.original:
      return "${getServerRoot()}$HOSTED_IMAGES_ORIGINALS_PATH${image
          .substring(HOSTED_IMAGE_PREFIX.length)}";
    case ImageType.thumbnail:
      return "${getServerRoot()}$HOSTED_IMAGES_THUMBNAILS_PATH${image
          .substring(HOSTED_IMAGE_PREFIX.length)}";
    default:
      throw new Exception("Not supported: $type");
  }
}

Element getParentElementRequired(Element start, String tagName) {
  Option<Element> output = getParentElement(start, tagName);
  if (output.isEmpty) throw new Exception("Parent ${tagName} not found");
  return output.get();
}

/// Gets the first parent [Element] that matches the specified [tagName].
Option<Element> getParentElement(Element start, String tagName) {
  if (start == null) return new None<Element>();
  if (start.tagName.toLowerCase() == tagName.toLowerCase())
    return new Some<Element>(start);
  if (start.parent == null) return new None<Element>();

  Element ele = start.parent;
  while (ele != null) {
    if (ele.tagName.toLowerCase() == tagName.toLowerCase())
      return new Some<Element>(ele);
    ele = ele.parent;
  }
  return new None<Element>();
}

/// Gets the protocol, domain, subdomain (if any), and port (if any) from the web site's request URL. Primarily for use in constructing an address to request the API from.
String getServerRoot() {
  final StringBuffer output = new StringBuffer();
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

/// Defines the different image types that can be requested from the server.
enum ImageType {
  /// The original, unaltered image file.
  original,

  /// A scaled-down, slightly more compressed, version of an original image file.
  thumbnail
}

/// Indicates that a data validation related error occured.
class ValidationException implements Exception {
  /// Validation error message.
  String message;

  /// Creates an instance of [ValidationException] with an error message.
  ValidationException(this.message);
}
