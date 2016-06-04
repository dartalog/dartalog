// This is a generated file (see the discoveryapis_generator project).

library dartalog.dartalog.D0_1;

import 'dart:core' as core;
import 'dart:collection' as collection_1;
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

  CollectionsResourceApi get collections => new CollectionsResourceApi(_requester);
  FieldsResourceApi get fields => new FieldsResourceApi(_requester);
  ImportResourceApi get import => new ImportResourceApi(_requester);
  ItemTypesResourceApi get itemTypes => new ItemTypesResourceApi(_requester);
  ItemsResourceApi get items => new ItemsResourceApi(_requester);
  PresetsResourceApi get presets => new PresetsResourceApi(_requester);
  UsersResourceApi get users => new UsersResourceApi(_requester);

  DartalogApi(http.Client client, {core.String rootUrl: "http://localhost:8080/", core.String servicePath: "dartalog/0.1/"}) :
      _requester = new commons.ApiRequester(client, rootUrl, servicePath, USER_AGENT);
}


class CollectionsResourceApi {
  final commons.ApiRequester _requester;

  CollectionsResourceApi(commons.ApiRequester client) : 
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
  async.Future<IdResponse> create(Collection request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'collections/';

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

    _url = 'collections/' + commons.Escaper.ecapeVariable('$id') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllIdsAndNames() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'collections/';

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
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [Collection].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Collection> getById(core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'collections/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new Collection.fromJson(data));
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
  async.Future<IdResponse> update(Collection request, core.String id) {
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

    _url = 'collections/' + commons.Escaper.ecapeVariable('$id') + '/';

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

    _url = 'fields/' + commons.Escaper.ecapeVariable('$id') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllIdsAndNames() {
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
  async.Future<Field> getById(core.String id) {
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

    _url = 'item_types/' + commons.Escaper.ecapeVariable('$id') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllIdsAndNames() {
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
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * [includeFields] - Query parameter: 'includeFields'.
   *
   * Completes with a [ItemType].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemType> getById(core.String id, {core.bool includeFields}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }
    if (includeFields != null) {
      _queryParams["includeFields"] = ["${includeFields}"];
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

  ItemsCopiesResourceApi get copies => new ItemsCopiesResourceApi(_requester);

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
   * Completes with a [ListOfItemListingResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfItemListingResponse> getAllListings() {
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
    return _response.then((data) => new ListOfItemListingResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * [includeType] - Query parameter: 'includeType'.
   *
   * [includeFields] - Query parameter: 'includeFields'.
   *
   * [includeCopies] - Query parameter: 'includeCopies'.
   *
   * Completes with a [Item].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Item> getById(core.String id, {core.bool includeType, core.bool includeFields, core.bool includeCopies}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }
    if (includeType != null) {
      _queryParams["includeType"] = ["${includeType}"];
    }
    if (includeFields != null) {
      _queryParams["includeFields"] = ["${includeFields}"];
    }
    if (includeCopies != null) {
      _queryParams["includeCopies"] = ["${includeCopies}"];
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


class ItemsCopiesResourceApi {
  final commons.ApiRequester _requester;

  ItemsCopiesResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [itemId] - Path parameter: 'itemId'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> create(ItemCopy request, core.String itemId) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (itemId == null) {
      throw new core.ArgumentError("Parameter itemId is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemId') + '/copies/';

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
   * [itemId] - Path parameter: 'itemId'.
   *
   * [copy] - Path parameter: 'copy'.
   *
   * Completes with a [ItemCopy].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemCopy> get(core.String itemId, core.int copy) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (itemId == null) {
      throw new core.ArgumentError("Parameter itemId is required.");
    }
    if (copy == null) {
      throw new core.ArgumentError("Parameter copy is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemId') + '/copies/' + commons.Escaper.ecapeVariable('$copy') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ItemCopy.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [itemId] - Path parameter: 'itemId'.
   *
   * Completes with a [ListOfItemCopy].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfItemCopy> getAllForItem(core.String itemId) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (itemId == null) {
      throw new core.ArgumentError("Parameter itemId is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemId') + '/copies/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ListOfItemCopy.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [itemId] - Path parameter: 'itemId'.
   *
   * [copy] - Path parameter: 'copy'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future performAction(ItemActionRequest request, core.String itemId, core.int copy) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (itemId == null) {
      throw new core.ArgumentError("Parameter itemId is required.");
    }
    if (copy == null) {
      throw new core.ArgumentError("Parameter copy is required.");
    }

    _downloadOptions = null;

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemId') + '/copies/' + commons.Escaper.ecapeVariable('$copy') + '/action/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

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
  async.Future performBulkAction(BulkItemActionRequest request) {
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

    _url = 'items/copies/bulk_action/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [itemId] - Path parameter: 'itemId'.
   *
   * [copy] - Path parameter: 'copy'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(ItemCopy request, core.String itemId, core.int copy) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }
    if (itemId == null) {
      throw new core.ArgumentError("Parameter itemId is required.");
    }
    if (copy == null) {
      throw new core.ArgumentError("Parameter copy is required.");
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemId') + '/copies/' + commons.Escaper.ecapeVariable('$copy') + '/';

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
}


class UsersResourceApi {
  final commons.ApiRequester _requester;

  UsersResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
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
  async.Future changePassword(PasswordChangeRequest request, core.String id) {
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

    _downloadOptions = null;

    _url = 'users/' + commons.Escaper.ecapeVariable('$id') + '/password/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => null);
  }

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
  async.Future<IdResponse> create(User request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'users/';

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

    _url = 'users/' + commons.Escaper.ecapeVariable('$id') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllIdsAndNames() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'users/';

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
   * Request parameters:
   *
   * [id] - Path parameter: 'id'.
   *
   * Completes with a [User].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<User> getById(core.String id) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (id == null) {
      throw new core.ArgumentError("Parameter id is required.");
    }

    _url = 'users/' + commons.Escaper.ecapeVariable('$id') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new User.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [User].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<User> getMe() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'current_user/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new User.fromJson(data));
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
  async.Future<IdResponse> update(User request, core.String id) {
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

    _url = 'users/' + commons.Escaper.ecapeVariable('$id') + '/';

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



class BulkItemActionRequest {
  core.String action;
  core.String actionerUserId;
  core.List<ItemCopyId> itemCopies;

  BulkItemActionRequest();

  BulkItemActionRequest.fromJson(core.Map _json) {
    if (_json.containsKey("action")) {
      action = _json["action"];
    }
    if (_json.containsKey("actionerUserId")) {
      actionerUserId = _json["actionerUserId"];
    }
    if (_json.containsKey("itemCopies")) {
      itemCopies = _json["itemCopies"].map((value) => new ItemCopyId.fromJson(value)).toList();
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (action != null) {
      _json["action"] = action;
    }
    if (actionerUserId != null) {
      _json["actionerUserId"] = actionerUserId;
    }
    if (itemCopies != null) {
      _json["itemCopies"] = itemCopies.map((value) => (value).toJson()).toList();
    }
    return _json;
  }
}

class Collection {
  core.String id;
  core.String name;

  Collection();

  Collection.fromJson(core.Map _json) {
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
  core.String location;

  IdResponse();

  IdResponse.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("location")) {
      location = _json["location"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (id != null) {
      _json["id"] = id;
    }
    if (location != null) {
      _json["location"] = location;
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
  core.List<ItemCopy> copies;
  core.int copyCount;
  core.List<core.String> fileUploads;
  core.String id;
  core.String name;
  ItemType type;
  core.String typeId;
  core.Map<core.String, core.String> values;

  Item();

  Item.fromJson(core.Map _json) {
    if (_json.containsKey("copies")) {
      copies = _json["copies"].map((value) => new ItemCopy.fromJson(value)).toList();
    }
    if (_json.containsKey("copyCount")) {
      copyCount = _json["copyCount"];
    }
    if (_json.containsKey("fileUploads")) {
      fileUploads = _json["fileUploads"];
    }
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
    if (copies != null) {
      _json["copies"] = copies.map((value) => (value).toJson()).toList();
    }
    if (copyCount != null) {
      _json["copyCount"] = copyCount;
    }
    if (fileUploads != null) {
      _json["fileUploads"] = fileUploads;
    }
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

class ItemActionRequest {
  core.String action;
  core.String actionerUserId;

  ItemActionRequest();

  ItemActionRequest.fromJson(core.Map _json) {
    if (_json.containsKey("action")) {
      action = _json["action"];
    }
    if (_json.containsKey("actionerUserId")) {
      actionerUserId = _json["actionerUserId"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (action != null) {
      _json["action"] = action;
    }
    if (actionerUserId != null) {
      _json["actionerUserId"] = actionerUserId;
    }
    return _json;
  }
}

class ItemCopy {
  Collection collection;
  core.String collectionId;
  core.int copy;
  core.String itemId;
  core.String status;
  core.String uniqueId;

  ItemCopy();

  ItemCopy.fromJson(core.Map _json) {
    if (_json.containsKey("collection")) {
      collection = new Collection.fromJson(_json["collection"]);
    }
    if (_json.containsKey("collectionId")) {
      collectionId = _json["collectionId"];
    }
    if (_json.containsKey("copy")) {
      copy = _json["copy"];
    }
    if (_json.containsKey("itemId")) {
      itemId = _json["itemId"];
    }
    if (_json.containsKey("status")) {
      status = _json["status"];
    }
    if (_json.containsKey("uniqueId")) {
      uniqueId = _json["uniqueId"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (collection != null) {
      _json["collection"] = (collection).toJson();
    }
    if (collectionId != null) {
      _json["collectionId"] = collectionId;
    }
    if (copy != null) {
      _json["copy"] = copy;
    }
    if (itemId != null) {
      _json["itemId"] = itemId;
    }
    if (status != null) {
      _json["status"] = status;
    }
    if (uniqueId != null) {
      _json["uniqueId"] = uniqueId;
    }
    return _json;
  }
}

class ItemCopyId {
  core.int copy;
  core.String itemId;

  ItemCopyId();

  ItemCopyId.fromJson(core.Map _json) {
    if (_json.containsKey("copy")) {
      copy = _json["copy"];
    }
    if (_json.containsKey("itemId")) {
      itemId = _json["itemId"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (copy != null) {
      _json["copy"] = copy;
    }
    if (itemId != null) {
      _json["itemId"] = itemId;
    }
    return _json;
  }
}

class ItemListingResponse {
  core.String id;
  core.String name;
  core.String thumbnail;
  core.String typeId;

  ItemListingResponse();

  ItemListingResponse.fromJson(core.Map _json) {
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
  core.String name;

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
    if (_json.containsKey("name")) {
      name = _json["name"];
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
    if (name != null) {
      _json["name"] = name;
    }
    return _json;
  }
}

class ListOfIdNamePair
    extends collection_1.ListBase<IdNamePair> {
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

class ListOfItemCopy
    extends collection_1.ListBase<ItemCopy> {
  final core.List<ItemCopy> _inner;

  ListOfItemCopy() : _inner = [];

  ListOfItemCopy.fromJson(core.List json)
      : _inner = json.map((value) => new ItemCopy.fromJson(value)).toList();

  core.List toJson() {
    return _inner.map((value) => (value).toJson()).toList();
  }

  ItemCopy operator [](core.int key) => _inner[key];

  void operator []=(core.int key, ItemCopy value) {
    _inner[key] = value;
  }

  core.int get length => _inner.length;

  void set length(core.int newLength) {
    _inner.length = newLength;
  }
}

class ListOfItemListingResponse
    extends collection_1.ListBase<ItemListingResponse> {
  final core.List<ItemListingResponse> _inner;

  ListOfItemListingResponse() : _inner = [];

  ListOfItemListingResponse.fromJson(core.List json)
      : _inner = json.map((value) => new ItemListingResponse.fromJson(value)).toList();

  core.List toJson() {
    return _inner.map((value) => (value).toJson()).toList();
  }

  ItemListingResponse operator [](core.int key) => _inner[key];

  void operator []=(core.int key, ItemListingResponse value) {
    _inner[key] = value;
  }

  core.int get length => _inner.length;

  void set length(core.int newLength) {
    _inner.length = newLength;
  }
}

class MapOfListOfString
    extends collection_1.MapBase<core.String, core.List<core.String>> {
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

class PasswordChangeRequest {
  core.String currentPassword;
  core.String newPassword;

  PasswordChangeRequest();

  PasswordChangeRequest.fromJson(core.Map _json) {
    if (_json.containsKey("currentPassword")) {
      currentPassword = _json["currentPassword"];
    }
    if (_json.containsKey("newPassword")) {
      newPassword = _json["newPassword"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (currentPassword != null) {
      _json["currentPassword"] = currentPassword;
    }
    if (newPassword != null) {
      _json["newPassword"] = newPassword;
    }
    return _json;
  }
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

class User {
  core.String id;
  core.String name;
  core.String password;

  User();

  User.fromJson(core.Map _json) {
    if (_json.containsKey("id")) {
      id = _json["id"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("password")) {
      password = _json["password"];
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
    if (password != null) {
      _json["password"] = password;
    }
    return _json;
  }
}
