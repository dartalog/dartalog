library client;

import 'dart:html';
import 'dart:async';

import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_source;

part 'src/dartalog_http_client.dart';

const String BROWSE_ROUTE_NAME = "browse";
const String BROWSE_ROUTE_PATH = "${BROWSE_ROUTE_NAME}";
const String SEARCH_ROUTE_NAME = "search";
const String SEARCH_ROUTE_PATH = "${SEARCH_ROUTE_NAME}";
const String ITEM_VIEW_ROUTE_NAME = "item_view";
const String ITEM_VIEW_ROUTE_PATH = "${ITEM_VIEW_ROUTE_NAME}";
const String ITEM_EDIT_ROUTE_NAME = "item_edit";
const String ITEM_EDIT_ROUTE_PATH = "${ITEM_EDIT_ROUTE_NAME}";
const String ITEM_ADD_ROUTE_NAME = "item_add";
const String ITEM_ADD_ROUTE_PATH = "${ITEM_ADD_ROUTE_NAME}";
const String ITEM_IMPORT_ROUTE_NAME = "item_import";
const String ITEM_IMPORT_ROUTE_PATH = "${ITEM_IMPORT_ROUTE_NAME}";
const String CHECKOUT_ROUTE_NAME = "checkout";
const String CHECKOUT_ROUTE_PATH = "${CHECKOUT_ROUTE_NAME}";


const String ROUTE_ARG_ITEM_ID_NAME = "itemId";
const String ROUTE_ARG_ITEM_TYPE_ID_NAME = "itemTypeId";
const String ROUTE_ARG_SEARCH_QUERY_NAME = "searchQuery";
const String ROUTE_ARG_IMPORT_RESULT_NAME= "importResults";

Element getParentElement(Element start, String tagName) {
  if(start==null)
    return null;
  if(start.tagName.toLowerCase()==tagName.toLowerCase())
    return start;
  if(start.parent==null)
    return null;

  Element ele = start.parent;
  while(ele!=null) {
    if(ele.tagName.toLowerCase()==tagName.toLowerCase())
      return ele;
    ele = ele.parent;
  }
  return null;
}

Element getChildElement(Element start, String tagName) {
  if(start==null)
    return null;
  if(start.tagName==tagName)
    return start;
  if(start.parent==null)
    return null;

  for(Element child in start.children) {
    if(child.tagName.toLowerCase()==tagName.toLowerCase())
      return child;
  }
  for(Element child in start.children) {
    Element candidate = getChildElement(child,tagName);
    if(candidate!=null)
      return candidate;
  }
  return null;
}

class ValidationException implements  Exception {
  String message;
  ValidationException(this.message);
}


abstract class HttpHeaders {
  static const String AUTHORIZATION = 'authorization';
}

String getServerRoot() {
  StringBuffer output = new StringBuffer();
  output.write(window.location.protocol);
  output.write("//");
  output.write(window.location.host);
  output.write("/");

  // When running in dev, since I use PHPStorm, the client runs via a different server than the dartalog server component
  return "http://localhost:3278/";

  return output.toString();
}

enum ImageType {
  ORIGINAL, THUMBNAIL
}

String getImageUrl(String image, ImageType type) {
  if(!image.startsWith(HOSTED_IMAGE_PREFIX))
    return image;

  switch(type) {
    case ImageType.ORIGINAL:
      return "${getServerRoot()}${HOSTED_IMAGES_ORIGINALS_PATH}${image.substring(HOSTED_IMAGE_PREFIX.length)}";
    case ImageType.THUMBNAIL:
      return "${getServerRoot()}${HOSTED_IMAGES_THUMBNAILS_PATH}${image.substring(HOSTED_IMAGE_PREFIX.length)}";
  }
}