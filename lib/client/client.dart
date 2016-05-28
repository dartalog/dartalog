library client;

import 'dart:html';

const String BROWSE_ROUTE_NAME = "browse";
const String BROWSE_ROUTE_PATH = "${BROWSE_ROUTE_NAME}";
const String ITEM_VIEW_ROUTE_NAME = "item_view";
const String ITEM_VIEW_ROUTE_PATH = "${ITEM_VIEW_ROUTE_NAME}";
const String ITEM_EDIT_ROUTE_NAME = "item_edit";
const String ITEM_EDIT_ROUTE_PATH = "${ITEM_EDIT_ROUTE_NAME}";
const String ITEM_ADD_ROUTE_NAME = "item_add";
const String ITEM_ADD_ROUTE_PATH = "${ITEM_ADD_ROUTE_NAME}";
const String ITEM_IMPORT_ROUTE_NAME = "item_import";
const String ITEM_IMPORT_ROUTE_PATH = "${ITEM_IMPORT_ROUTE_NAME}";


const String ROUTE_ARG_ITEM_ID_NAME = "itemId";
const String ROUTE_ARG_ITEM_TYPE_ID_NAME = "itemTypeId";

void handleException(dynamic e) {
  if(e is ValidationException) {

  }
}

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