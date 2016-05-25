library client;

import 'dart:html';

const String BROWSE_ROUTE_NAME = "browse";
const String ITEM_VIEW_ROUTE_NAME = "item_view";
const String ITEM_VIEW_ROUTE_PATH = "${BROWSE_ROUTE_NAME}.item_view";
const String ITEM_VIEW_ROUTE_ARG_ITEM_ID_NAME = "itemId";

void handleException(dynamic e) {
  if(e is ValidationException) {

  }
}

Element getParentElement(Element start, String tagName) {
  if(start==null)
    return null;
  if(start.tagName==tagName)
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