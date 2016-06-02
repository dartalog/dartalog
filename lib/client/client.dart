library client;

import 'dart:html';
import 'dart:async';
import 'dart:indexed_db' as idb;

import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';


part 'src/dartalog_http_client.dart';

const String SERVER_ADDRESS = "http://localhost:3278/";

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

const String _DARTALOG_IDB_NAME = "dartalog";
const String _DARTALOG_IDB_SETTINGS_STORE = "settings";
const int _DARTALOG_IDB_VERSION = 1;
const String AUTH_KEY_NAME = "authKey";

String _cachedAuthKey = "";

idb.Database _db;

Future openIndexedDb() async {
  if(_db==null)
  _db = await window.indexedDB.open(_DARTALOG_IDB_NAME, version: _DARTALOG_IDB_VERSION, onUpgradeNeeded: _onUpgradeNeeded);
}

void _onUpgradeNeeded(idb.VersionChangeEvent e) {
  idb.Database db = (e.target as idb.OpenDBRequest).result;
  if (!db.objectStoreNames.contains(_DARTALOG_IDB_SETTINGS_STORE)) {
    db.createObjectStore(_DARTALOG_IDB_SETTINGS_STORE, keyPath: 'id');
  }
}

Future<Option<String>> getCachedAuthKey() async {
  if(!isNullOrWhitespace(_cachedAuthKey))
    return new Some(_cachedAuthKey);

  if (!idb.IdbFactory.supported)
    return new None(); //TODO: Implement alternative auth caching mechanism

  var trans = _db.transaction(_DARTALOG_IDB_SETTINGS_STORE, 'read');
  var store = trans.objectStore(_DARTALOG_IDB_SETTINGS_STORE);
  dynamic obj = await store.getObject({"id": AUTH_KEY_NAME});
  Option output = new Some(obj["value"]);
  output.map((value) => _cachedAuthKey = value);
  return output;
}

Future cacheAuthKey(String text) async {
  var trans = _db.transaction(_DARTALOG_IDB_SETTINGS_STORE, 'readwrite');
  var store = trans.objectStore(_DARTALOG_IDB_SETTINGS_STORE);
  await store.put({
    'id': AUTH_KEY_NAME,
    'value': text
  });
}

abstract class HttpHeaders {
  static const String AUTHORIZATION = 'authorization';
}