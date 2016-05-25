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
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> create(Field request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'fields/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [Field].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Field> get(core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'fields/' + commons.Escaper.ecapeVariable('$id') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAll() {
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
    return _response.then((data) => new ListOfIdNamePair.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(Field request, core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'fields/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
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
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> create(ItemType request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'item_types/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * [expand] - Query parameter: 'expand'.
   *
   * Completes with a [ItemType].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemType> get(core.String id, {core.String expand}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }
    if (expand != null) {
      _queryParams["expand"] = [expand];
    }

    _url = 'item_types/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemType.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAll() {
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
    return _response.then((data) => new ListOfIdNamePair.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(ItemType request, core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'item_types/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
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
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> create(Item request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'items/';

    var _response = _requester.request(_url,
                                       "POST",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _downloadOptions = null;

    _url = 'items/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "DELETE",
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
   * [id] - Path parameter: 'id'.
   *
   * [expand] - Query parameter: 'expand'.
   *
   * Completes with a [Item].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Item> get(core.String id, {core.String expand}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }
    if (expand != null) {
      _queryParams["expand"] = [expand];
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new Item.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [ListOfItemListing].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfItemListing> getAll() {
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
    return _response.then((data) => new ListOfItemListing.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(Item request, core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
  }

}


class PresetsResourceApi {
  final commons.ApiRequester _requester;

  PresetsResourceApi(commons.ApiRequester client) : 
      _requester = client;

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

}



class Field {
  core.String format;
  core.String id;
  core.String name;
  core.String type;

  Field();

  Field.fromJson(core.Map _json) {
    if (_json.containsKey("format")) {
      format = _json["format"];
    }
    if (_json.containsKey("id")) {
      id = _json["id"];
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
    if (id != null) {
      _json["id"] = id;
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

class IdNamePair {
  core.String id;
  core.String name;

  IdNamePair();

  IdNamePair.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}

class IdResponse {
  core.String id;

  IdResponse();

  IdResponse.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    return _json;
  }
}

class ImportResult {
  core.String debug;
  core.String itemId;
  core.String itemSource;
  core.String itemType;
  core.String itemUrl;
  core.Map<core.String, core.List<core.String>> values;

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
    if (_json.containsKey("itemType")) {
      itemType = _json["itemType"];
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
    if (itemType != null) {
      _json["itemType"] = itemType;
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
  core.String id;
  core.String name;
  ItemType type;
  core.String typeId;
  core.Map<core.String, core.String> values;

  Item();

  Item.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("type")) {
      type = new ItemType.fromJson(_json["type"]);
    }
    if (_json.containsKey("typeId")) {
      typeId = _json["typeId"];
    }
    if (_json.containsKey("values")) {
      values = _json["values"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (type != null) {
      _json["type"] = (type).toJson();
    }
    if (typeId != null) {
      _json["typeId"] = typeId;
    }
    if (values != null) {
      _json["values"] = values;
    }
    return _json;
  }
}

class ItemListing {
  core.String id;
  core.String name;
  core.String thumbnail;
  core.String typeId;

  ItemListing();

  ItemListing.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("thumbnail")) {
      thumbnail = _json["thumbnail"];
    }
    if (_json.containsKey("typeId")) {
      typeId = _json["typeId"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (thumbnail != null) {
      _json["thumbnail"] = thumbnail;
    }
    if (typeId != null) {
      _json["typeId"] = typeId;
    }
    return _json;
  }
}

class ItemType {
  core.List<core.String> fieldIds;
  core.List<Field> fields;
  core.String id;
  core.List<core.String> itemNameFields;
  core.String name;
  core.List<core.String> subTypes;

  ItemType();

  ItemType.fromJson(core.Map _json) {
    if (_json.containsKey("fieldIds")) {
      fieldIds = _json["fieldIds"];
    }
    if (_json.containsKey("fields")) {
      fields = _json["fields"].map((value) => new Field.fromJson(value)).toList();
    }
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("itemNameFields")) {
      itemNameFields = _json["itemNameFields"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("subTypes")) {
      subTypes = _json["subTypes"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fieldIds != null) {
      _json["fieldIds"] = fieldIds;
    }
    if (fields != null) {
      _json["fields"] = fields.map((value) => (value).toJson()).toList();
    }
    if (id != null) {
      _json["id"] = id;
    }
    if (itemNameFields != null) {
      _json["itemNameFields"] = itemNameFields;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (subTypes != null) {
      _json["subTypes"] = subTypes;
    }
    return _json;
  }
}

class ListOfIdNamePair
    extends collection.ListBase<IdNamePair> {
  final core.List<IdNamePair> _inner;

  ListOfIdNamePair() : _inner = [];

  ListOfIdNamePair.fromJson(core.List json)
      : _inner = json.map((value) => new IdNamePair.fromJson(value)).toList();

  core.List toJson() {
    return _inner.map((value) => (value).toJson()).toList();
  }

  IdNamePair operator [](core.int key) => _inner[key];

  void operator []=(core.int key, IdNamePair value) {
    _inner[key] = value;
  }

  core.int get length => _inner.length;

  void set length(core.int newLength) {
    _inner.length = newLength;
  }
}

class ListOfItemListing
    extends collection.ListBase<ItemListing> {
  final core.List<ItemListing> _inner;

  ListOfItemListing() : _inner = [];

  ListOfItemListing.fromJson(core.List json)
      : _inner = json.map((value) => new ItemListing.fromJson(value)).toList();

  core.List toJson() {
    return _inner.map((value) => (value).toJson()).toList();
  }

  ItemListing operator [](core.int key) => _inner[key];

  void operator []=(core.int key, ItemListing value) {
    _inner[key] = value;
  }

  core.int get length => _inner.length;

  void set length(core.int newLength) {
    _inner.length = newLength;
  }
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
