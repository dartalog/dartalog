// This is a generated file (see the discoveryapis_generator project).

library dartalog.dartalog.D0_1;

import 'dart:core' as core;
import 'dart:collection' as collection;
import 'dart:async' as async;
import 'dart:convert' as convert;

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:http/http.dart' as http;

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart' show
    ApiRequestError, DetailedApiRequestError;

const core.String USER_AGENT = 'dart-api-client dartalog/0.1';

/** Dartalog REST API */
class DartalogApi {

  final commons.ApiRequester _requester;

  FieldsResourceApi get fields => new FieldsResourceApi(_requester);
  ImportResourceApi get import => new ImportResourceApi(_requester);
  ItemTypesResourceApi get itemTypes => new ItemTypesResourceApi(_requester);
  ItemsResourceApi get items => new ItemsResourceApi(_requester);
  PresetsResourceApi get presets => new PresetsResourceApi(_requester);

  DartalogApi(http.Client client, {core.String rootUrl: "http://localhost:8080/", core.String servicePath: "dartalog/0.1/"}) :
      _requester = new commons.ApiRequester(client, rootUrl, servicePath, USER_AGENT);
}


class FieldsResourceApi {
  final commons.ApiRequester _requester;

  FieldsResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(Field request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'fields/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [Field].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Field> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'fields/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new Field.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfField].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfField> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'fields/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfField.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [UuidResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<UuidResponse> update(Field request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'fields/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new UuidResponse.fromJson(data));
  }

}


class ImportResourceApi {
  final commons.ApiRequester _requester;

  ImportResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * Request parameters:
   *
   * [provider] - Path parameter: 'provider'.
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [ImportResult].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ImportResult> import(core.String provider, core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (provider == null) {
      throw new core.ArgumentError("Parameter provider is required.");
    }
    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'import/' + commons.Escaper.ecapeVariable('$provider') + '/' + commons.Escaper.ecapeVariable('$id');

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ImportResult.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfListOfString].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfListOfString> listProviders() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'import/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfListOfString.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [provider] - Path parameter: 'provider'.
   *
   * [query] - Path parameter: 'query'.
   *
   * [template] - Query parameter: 'template'.
   *
   * [page] - Query parameter: 'page'.
   *
   * Completes with a [SearchResults].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<SearchResults> search(core.String provider, core.String query, {core.String template, core.int page}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (provider == null) {
      throw new core.ArgumentError("Parameter provider is required.");
    }
    if (query == null) {
      throw new core.ArgumentError("Parameter query is required.");
    }
    if (template != null) {
      _queryParams["template"] = [template];
    }
    if (page != null) {
      _queryParams["page"] = ["${page}"];
    }

    _url = 'import/' + commons.Escaper.ecapeVariable('$provider') + '/search/' + commons.Escaper.ecapeVariable('$query');

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new SearchResults.fromJson(data));
  }

}


class ItemTypesResourceApi {
  final commons.ApiRequester _requester;

  ItemTypesResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(ItemType request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'item_types/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [ItemTypeResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemTypeResponse> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'item_types/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemTypeResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfItemType].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfItemType> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'item_types/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfItemType.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future update(ItemType request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'item_types/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}


class ItemsResourceApi {
  final commons.ApiRequester _requester;

  ItemsResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future create(Item request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _downloadOptions = null;

    _url = 'items/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [ItemResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemResponse> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfItem].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfItem> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'items/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfItem.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future update(Item request, core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}


class PresetsResourceApi {
  final commons.ApiRequester _requester;

  PresetsResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [ItemTypeResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemTypeResponse> get(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'presets/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemTypeResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [MapOfString].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<MapOfString> getAll() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'presets/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new MapOfString.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future install(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _downloadOptions = null;

    _url = 'presets/' + commons.Escaper.ecapeVariable('$uuid') + '/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

}



class Field {
  core.String format;
  core.String name;
  core.String type;

  Field();

  Field.fromJson(core.Map _json) {
    if (_json.containsKey("format")) {
      format = _json["format"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("type")) {
      type = _json["type"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (format != null) {
      _json["format"] = format;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (type != null) {
      _json["type"] = type;
    }
    return _json;
  }
}

class ImportResult {
  core.String debug;
  core.String itemId;
  core.String itemSource;
  core.String itemUrl;
  core.Map<core.String, core.String> values;

  ImportResult();

  ImportResult.fromJson(core.Map _json) {
    if (_json.containsKey("debug")) {
      debug = _json["debug"];
    }
    if (_json.containsKey("itemId")) {
      itemId = _json["itemId"];
    }
    if (_json.containsKey("itemSource")) {
      itemSource = _json["itemSource"];
    }
    if (_json.containsKey("itemUrl")) {
      itemUrl = _json["itemUrl"];
    }
    if (_json.containsKey("values")) {
      values = _json["values"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (debug != null) {
      _json["debug"] = debug;
    }
    if (itemId != null) {
      _json["itemId"] = itemId;
    }
    if (itemSource != null) {
      _json["itemSource"] = itemSource;
    }
    if (itemUrl != null) {
      _json["itemUrl"] = itemUrl;
    }
    if (values != null) {
      _json["values"] = values;
    }
    return _json;
  }
}

class Item {
  core.Map<core.String, core.String> fieldValues;
  core.String template;

  Item();

  Item.fromJson(core.Map _json) {
    if (_json.containsKey("fieldValues")) {
      fieldValues = _json["fieldValues"];
    }
    if (_json.containsKey("template")) {
      template = _json["template"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fieldValues != null) {
      _json["fieldValues"] = fieldValues;
    }
    if (template != null) {
      _json["template"] = template;
    }
    return _json;
  }
}

class ItemResponse {
  core.Map<core.String, Field> fields;
  Item item;
  ItemType template;

  ItemResponse();

  ItemResponse.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = commons.mapMap(_json["fields"], (item) => new Field.fromJson(item));
    }
    if (_json.containsKey("item")) {
      item = new Item.fromJson(_json["item"]);
    }
    if (_json.containsKey("template")) {
      template = new ItemType.fromJson(_json["template"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = commons.mapMap(fields, (item) => (item).toJson());
    }
    if (item != null) {
      _json["item"] = (item).toJson();
    }
    if (template != null) {
      _json["template"] = (template).toJson();
    }
    return _json;
  }
}

class ItemType {
  core.List<core.String> fields;
  core.String name;

  ItemType();

  ItemType.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = _json["fields"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = fields;
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}

class ItemTypeResponse {
  core.Map<core.String, Field> fields;
  ItemType itemType;

  ItemTypeResponse();

  ItemTypeResponse.fromJson(core.Map _json) {
    if (_json.containsKey("fields")) {
      fields = commons.mapMap(_json["fields"], (item) => new Field.fromJson(item));
    }
    if (_json.containsKey("itemType")) {
      itemType = new ItemType.fromJson(_json["itemType"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fields != null) {
      _json["fields"] = commons.mapMap(fields, (item) => (item).toJson());
    }
    if (itemType != null) {
      _json["itemType"] = (itemType).toJson();
    }
    return _json;
  }
}

class MapOfField
    extends collection.MapBase<core.String, Field> {
  final core.Map _innerMap = {};

  MapOfField();

  MapOfField.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new Field.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  Field operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, Field value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  Field remove(core.Object key) => _innerMap.remove(key);
}

class MapOfItem
    extends collection.MapBase<core.String, Item> {
  final core.Map _innerMap = {};

  MapOfItem();

  MapOfItem.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new Item.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  Item operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, Item value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  Item remove(core.Object key) => _innerMap.remove(key);
}

class MapOfItemType
    extends collection.MapBase<core.String, ItemType> {
  final core.Map _innerMap = {};

  MapOfItemType();

  MapOfItemType.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = new ItemType.fromJson(value);
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = (value).toJson();
    });
    return _json;
  }

  ItemType operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, ItemType value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  ItemType remove(core.Object key) => _innerMap.remove(key);
}

class MapOfListOfString
    extends collection.MapBase<core.String, core.List<core.String>> {
  final core.Map _innerMap = {};

  MapOfListOfString();

  MapOfListOfString.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = value;
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = value;
    });
    return _json;
  }

  core.List<core.String> operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, core.List<core.String> value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  core.List<core.String> remove(core.Object key) => _innerMap.remove(key);
}

class MapOfString
    extends collection.MapBase<core.String, core.String> {
  final core.Map _innerMap = {};

  MapOfString();

  MapOfString.fromJson(core.Map _json) {
    _json.forEach((core.String key, value) {
      this[key] = value;
    });
  }

  core.Map toJson() {
    var _json = {};
    this.forEach((core.String key, value) {
      _json[key] = value;
    });
    return _json;
  }

  core.String operator [](core.Object key)
      => _innerMap[key];

  operator []=(core.String key, core.String value) {
    _innerMap[key] = value;
  }

  void clear() {
    _innerMap.clear();
  }

  core.Iterable<core.String> get keys => _innerMap.keys;

  core.String remove(core.Object key) => _innerMap.remove(key);
}

class SearchResult {
  core.String debug;
  core.String id;
  core.String thumbnail;
  core.String title;
  core.String url;

  SearchResult();

  SearchResult.fromJson(core.Map _json) {
    if (_json.containsKey("debug")) {
      debug = _json["debug"];
    }
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("thumbnail")) {
      thumbnail = _json["thumbnail"];
    }
    if (_json.containsKey("title")) {
      title = _json["title"];
    }
    if (_json.containsKey("url")) {
      url = _json["url"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (debug != null) {
      _json["debug"] = debug;
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (thumbnail != null) {
      _json["thumbnail"] = thumbnail;
    }
    if (title != null) {
      _json["title"] = title;
    }
    if (url != null) {
      _json["url"] = url;
    }
    return _json;
  }
}

class SearchResults {
  core.int currentPage;
  core.Map<core.String, core.String> data;
  core.List<SearchResult> results;
  core.String searchUrl;
  core.int totalPages;
  core.int totalResults;

  SearchResults();

  SearchResults.fromJson(core.Map _json) {
    if (_json.containsKey("currentPage")) {
      currentPage = _json["currentPage"];
    }
    if (_json.containsKey("data")) {
      data = _json["data"];
    }
    if (_json.containsKey("results")) {
      results = _json["results"].map((value) => new SearchResult.fromJson(value)).toList();
    }
    if (_json.containsKey("searchUrl")) {
      searchUrl = _json["searchUrl"];
    }
    if (_json.containsKey("totalPages")) {
      totalPages = _json["totalPages"];
    }
    if (_json.containsKey("totalResults")) {
      totalResults = _json["totalResults"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (currentPage != null) {
      _json["currentPage"] = currentPage;
    }
    if (data != null) {
      _json["data"] = data;
    }
    if (results != null) {
      _json["results"] = results.map((value) => (value).toJson()).toList();
    }
    if (searchUrl != null) {
      _json["searchUrl"] = searchUrl;
    }
    if (totalPages != null) {
      _json["totalPages"] = totalPages;
    }
    if (totalResults != null) {
      _json["totalResults"] = totalResults;
    }
    return _json;
  }
}

class UuidResponse {
  core.String uuid;

  UuidResponse();

  UuidResponse.fromJson(core.Map _json) {
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}
