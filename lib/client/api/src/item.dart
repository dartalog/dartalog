// This is a generated file (see the discoveryapis_generator project).

library dartalog.item.D0_1;

import 'dart:core' as core;
import 'dart:collection' as collection_1;
import 'dart:async' as async;
import 'dart:convert' as convert;

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:http/http.dart' as http;

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart' show
    ApiRequestError, DetailedApiRequestError;

const core.String USER_AGENT = 'dart-api-client item/0.1';

/** Item REST API */
class ItemApi {

  final commons.ApiRequester _requester;

  CollectionsResourceApi get collections => new CollectionsResourceApi(_requester);
  ExportResourceApi get export => new ExportResourceApi(_requester);
  FieldsResourceApi get fields => new FieldsResourceApi(_requester);
  ImportResourceApi get import => new ImportResourceApi(_requester);
  ItemTypesResourceApi get itemTypes => new ItemTypesResourceApi(_requester);
  ItemsResourceApi get items => new ItemsResourceApi(_requester);
  PresetsResourceApi get presets => new PresetsResourceApi(_requester);
  SetupResourceApi get setup => new SetupResourceApi(_requester);
  UsersResourceApi get users => new UsersResourceApi(_requester);

  ItemApi(http.Client client, {core.String rootUrl: "http://localhost:8080/", core.String servicePath: "item/0.1/"}) :
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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'collections/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [Collection].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Collection> getByUuid(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'collections/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(Collection request, core.String uuid) {
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

    _url = 'collections/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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


class ExportResourceApi {
  final commons.ApiRequester _requester;

  ExportResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * Request parameters:
   *
   * Completes with a [ListOfCollection].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfCollection> exportCollections() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'export/collections/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new ListOfCollection.fromJson(data));
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
  async.Future<IdResponse> applyTemplate(IdRequest request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'templates/fields/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'fields/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllTemplates() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'templates/fields/';

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
  async.Future<Field> getByUuid(core.String uuid) {
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
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(Field request, core.String uuid) {
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
  async.Future<SearchResults> search(core.String provider, core.String query, {core.int page}) {
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
  async.Future<IdResponse> applyTemplate(IdRequest request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'templates/types/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new IdResponse.fromJson(data));
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

    _url = 'types/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'types/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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


    _url = 'types/';

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
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getAllTemplates() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'templates/types/';

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
   * [uuid] - Path parameter: 'uuid'.
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
  async.Future<ItemType> getByUuid(core.String uuid, {core.bool includeFields}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }
    if (includeFields != null) {
      _queryParams["includeFields"] = ["${includeFields}"];
    }

    _url = 'types/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(ItemType request, core.String uuid) {
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

    _url = 'types/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
  async.Future<IdResponse> createItemWithCopy(CreateItemRequest request) {
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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuidOrReadableId] - Path parameter: 'uuidOrReadableId'.
   *
   * [includeType] - Query parameter: 'includeType'.
   *
   * [includeFields] - Query parameter: 'includeFields'.
   *
   * [includeCopies] - Query parameter: 'includeCopies'.
   *
   * [includeCopyCollection] - Query parameter: 'includeCopyCollection'.
   *
   * Completes with a [Item].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<Item> getByUuidOrReadableId(core.String uuidOrReadableId, {core.bool includeType, core.bool includeFields, core.bool includeCopies, core.bool includeCopyCollection}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuidOrReadableId == null) {
      throw new core.ArgumentError("Parameter uuidOrReadableId is required.");
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
    if (includeCopyCollection != null) {
      _queryParams["includeCopyCollection"] = ["${includeCopyCollection}"];
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuidOrReadableId') + '/';

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
   * [page] - Query parameter: 'page'.
   *
   * [perPage] - Query parameter: 'perPage'.
   *
   * Completes with a [PaginatedResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<PaginatedResponse> getVisibleSummaries({core.int page, core.int perPage}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (page != null) {
      _queryParams["page"] = ["${page}"];
    }
    if (perPage != null) {
      _queryParams["perPage"] = ["${perPage}"];
    }

    _url = 'items/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new PaginatedResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * [query] - Path parameter: 'query'.
   *
   * [page] - Query parameter: 'page'.
   *
   * [perPage] - Query parameter: 'perPage'.
   *
   * Completes with a [PaginatedResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<PaginatedResponse> searchVisible(core.String query, {core.int page, core.int perPage}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (query == null) {
      throw new core.ArgumentError("Parameter query is required.");
    }
    if (page != null) {
      _queryParams["page"] = ["${page}"];
    }
    if (perPage != null) {
      _queryParams["perPage"] = ["${perPage}"];
    }

    _url = 'search/' + commons.Escaper.ecapeVariable('$query') + '/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new PaginatedResponse.fromJson(data));
  }

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> updateItem(UpdateItemRequest request, core.String uuid) {
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

    _url = 'items/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> create(ItemCopy request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'copies/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'copies/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuidOrUniqueId] - Path parameter: 'uuidOrUniqueId'.
   *
   * [includeCollection] - Query parameter: 'includeCollection'.
   *
   * [includeItemSummary] - Query parameter: 'includeItemSummary'.
   *
   * Completes with a [ItemCopy].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ItemCopy> getByUuidOrUniqueId(core.String uuidOrUniqueId, {core.bool includeCollection, core.bool includeItemSummary}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuidOrUniqueId == null) {
      throw new core.ArgumentError("Parameter uuidOrUniqueId is required.");
    }
    if (includeCollection != null) {
      _queryParams["includeCollection"] = ["${includeCollection}"];
    }
    if (includeItemSummary != null) {
      _queryParams["includeItemSummary"] = ["${includeItemSummary}"];
    }

    _url = 'copies/' + commons.Escaper.ecapeVariable('$uuidOrUniqueId') + '/';

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
   * [itemUuidOrReadableId] - Path parameter: 'itemUuidOrReadableId'.
   *
   * [includeCollection] - Query parameter: 'includeCollection'.
   *
   * Completes with a [ListOfItemCopy].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfItemCopy> getVisibleForItem(core.String itemUuidOrReadableId, {core.bool includeCollection}) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (itemUuidOrReadableId == null) {
      throw new core.ArgumentError("Parameter itemUuidOrReadableId is required.");
    }
    if (includeCollection != null) {
      _queryParams["includeCollection"] = ["${includeCollection}"];
    }

    _url = 'items/' + commons.Escaper.ecapeVariable('$itemUuidOrReadableId') + '/copies/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future performAction(ItemActionRequest request, core.String uuid) {
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

    _url = 'copies/' + commons.Escaper.ecapeVariable('$uuid') + '/action/';

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

    _url = 'bulk/copies/action/';

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
  async.Future transfer(TransferRequest request) {
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

    _url = 'bulk/copies/transfer/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(ItemCopy request, core.String uuid) {
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

    _url = 'copies/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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


class SetupResourceApi {
  final commons.ApiRequester _requester;

  SetupResourceApi(commons.ApiRequester client) : 
      _requester = client;

  /**
   * [request] - The metadata request object.
   *
   * Request parameters:
   *
   * Completes with a [SetupResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<SetupResponse> apply(SetupRequest request) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (request != null) {
      _body = convert.JSON.encode((request).toJson());
    }

    _url = 'setup/';

    var _response = _requester.request(_url,
                                       "PUT",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new SetupResponse.fromJson(data));
  }

  /**
   * Request parameters:
   *
   * Completes with a [SetupResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<SetupResponse> get() {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;


    _url = 'setup/';

    var _response = _requester.request(_url,
                                       "GET",
                                       body: _body,
                                       queryParams: _queryParams,
                                       uploadOptions: _uploadOptions,
                                       uploadMedia: _uploadMedia,
                                       downloadOptions: _downloadOptions);
    return _response.then((data) => new SetupResponse.fromJson(data));
  }

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future changePassword(PasswordChangeRequest request, core.String uuid) {
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

    _url = 'users/' + commons.Escaper.ecapeVariable('$uuid') + '/password/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future delete(core.String uuid) {
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

    _url = 'users/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [ListOfIdNamePair].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<ListOfIdNamePair> getBorrowedItems(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'users/' + commons.Escaper.ecapeVariable('$uuid') + '/borrowed/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [User].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<User> getByUuid(core.String uuid) {
    var _url = null;
    var _queryParams = new core.Map();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    if (uuid == null) {
      throw new core.ArgumentError("Parameter uuid is required.");
    }

    _url = 'users/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
   * [uuid] - Path parameter: 'uuid'.
   *
   * Completes with a [IdResponse].
   *
   * Completes with a [commons.ApiRequestError] if the API endpoint returned an
   * error.
   *
   * If the used [http.Client] completes with an error when making a REST call,
   * this method will complete with the same error.
   */
  async.Future<IdResponse> update(User request, core.String uuid) {
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

    _url = 'users/' + commons.Escaper.ecapeVariable('$uuid') + '/';

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
  core.String actionerUserUuid;
  core.List<core.String> itemCopyUuids;

  BulkItemActionRequest();

  BulkItemActionRequest.fromJson(core.Map _json) {
    if (_json.containsKey("action")) {
      action = _json["action"];
    }
    if (_json.containsKey("actionerUserUuid")) {
      actionerUserUuid = _json["actionerUserUuid"];
    }
    if (_json.containsKey("itemCopyUuids")) {
      itemCopyUuids = _json["itemCopyUuids"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (action != null) {
      _json["action"] = action;
    }
    if (actionerUserUuid != null) {
      _json["actionerUserUuid"] = actionerUserUuid;
    }
    if (itemCopyUuids != null) {
      _json["itemCopyUuids"] = itemCopyUuids;
    }
    return _json;
  }
}

class Collection {
  core.List<core.String> browserUuids;
  core.List<core.String> curatorUuids;
  core.String name;
  core.bool publiclyBrowsable;
  core.String readableId;
  core.String uuid;

  Collection();

  Collection.fromJson(core.Map _json) {
    if (_json.containsKey("browserUuids")) {
      browserUuids = _json["browserUuids"];
    }
    if (_json.containsKey("curatorUuids")) {
      curatorUuids = _json["curatorUuids"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("publiclyBrowsable")) {
      publiclyBrowsable = _json["publiclyBrowsable"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (browserUuids != null) {
      _json["browserUuids"] = browserUuids;
    }
    if (curatorUuids != null) {
      _json["curatorUuids"] = curatorUuids;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (publiclyBrowsable != null) {
      _json["publiclyBrowsable"] = publiclyBrowsable;
    }
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class CreateItemRequest {
  core.String collectionUuid;
  core.List<MediaMessage> files;
  Item item;
  core.String uniqueId;

  CreateItemRequest();

  CreateItemRequest.fromJson(core.Map _json) {
    if (_json.containsKey("collectionUuid")) {
      collectionUuid = _json["collectionUuid"];
    }
    if (_json.containsKey("files")) {
      files = _json["files"].map((value) => new MediaMessage.fromJson(value)).toList();
    }
    if (_json.containsKey("item")) {
      item = new Item.fromJson(_json["item"]);
    }
    if (_json.containsKey("uniqueId")) {
      uniqueId = _json["uniqueId"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (collectionUuid != null) {
      _json["collectionUuid"] = collectionUuid;
    }
    if (files != null) {
      _json["files"] = files.map((value) => (value).toJson()).toList();
    }
    if (item != null) {
      _json["item"] = (item).toJson();
    }
    if (uniqueId != null) {
      _json["uniqueId"] = uniqueId;
    }
    return _json;
  }
}

class Field {
  core.String format;
  core.String name;
  core.String readableId;
  core.String type;
  core.bool unique;
  core.String uuid;

  Field();

  Field.fromJson(core.Map _json) {
    if (_json.containsKey("format")) {
      format = _json["format"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("type")) {
      type = _json["type"];
    }
    if (_json.containsKey("unique")) {
      unique = _json["unique"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
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
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (type != null) {
      _json["type"] = type;
    }
    if (unique != null) {
      _json["unique"] = unique;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class IdNamePair {
  core.String name;
  core.String readableId;
  core.String uuid;

  IdNamePair();

  IdNamePair.fromJson(core.Map _json) {
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (name != null) {
      _json["name"] = name;
    }
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class IdRequest {
  core.String id;

  IdRequest();

  IdRequest.fromJson(core.Map _json) {
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

class IdResponse {
  core.String location;
  core.String uuid;

  IdResponse();

  IdResponse.fromJson(core.Map _json) {
    if (_json.containsKey("location")) {
      location = _json["location"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (location != null) {
      _json["location"] = location;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class ImportResult {
  core.String debug;
  core.String itemId;
  core.String itemSource;
  core.String itemTypeId;
  core.String itemTypeName;
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
    if (_json.containsKey("itemTypeId")) {
      itemTypeId = _json["itemTypeId"];
    }
    if (_json.containsKey("itemTypeName")) {
      itemTypeName = _json["itemTypeName"];
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
    if (itemTypeId != null) {
      _json["itemTypeId"] = itemTypeId;
    }
    if (itemTypeName != null) {
      _json["itemTypeName"] = itemTypeName;
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
  core.bool canDelete;
  core.bool canEdit;
  core.List<ItemCopy> copies;
  core.DateTime dateAdded;
  core.DateTime dateUpdated;
  core.String name;
  core.String readableId;
  ItemType type;
  core.String typeUuid;
  core.String uuid;
  core.Map<core.String, core.String> values;

  Item();

  Item.fromJson(core.Map _json) {
    if (_json.containsKey("canDelete")) {
      canDelete = _json["canDelete"];
    }
    if (_json.containsKey("canEdit")) {
      canEdit = _json["canEdit"];
    }
    if (_json.containsKey("copies")) {
      copies = _json["copies"].map((value) => new ItemCopy.fromJson(value)).toList();
    }
    if (_json.containsKey("dateAdded")) {
      dateAdded = core.DateTime.parse(_json["dateAdded"]);
    }
    if (_json.containsKey("dateUpdated")) {
      dateUpdated = core.DateTime.parse(_json["dateUpdated"]);
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("type")) {
      type = new ItemType.fromJson(_json["type"]);
    }
    if (_json.containsKey("typeUuid")) {
      typeUuid = _json["typeUuid"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
    if (_json.containsKey("values")) {
      values = _json["values"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (canDelete != null) {
      _json["canDelete"] = canDelete;
    }
    if (canEdit != null) {
      _json["canEdit"] = canEdit;
    }
    if (copies != null) {
      _json["copies"] = copies.map((value) => (value).toJson()).toList();
    }
    if (dateAdded != null) {
      _json["dateAdded"] = (dateAdded).toIso8601String();
    }
    if (dateUpdated != null) {
      _json["dateUpdated"] = (dateUpdated).toIso8601String();
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (type != null) {
      _json["type"] = (type).toJson();
    }
    if (typeUuid != null) {
      _json["typeUuid"] = typeUuid;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    if (values != null) {
      _json["values"] = values;
    }
    return _json;
  }
}

class ItemActionRequest {
  core.String action;
  core.String actionerUserUuid;

  ItemActionRequest();

  ItemActionRequest.fromJson(core.Map _json) {
    if (_json.containsKey("action")) {
      action = _json["action"];
    }
    if (_json.containsKey("actionerUserUuid")) {
      actionerUserUuid = _json["actionerUserUuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (action != null) {
      _json["action"] = action;
    }
    if (actionerUserUuid != null) {
      _json["actionerUserUuid"] = actionerUserUuid;
    }
    return _json;
  }
}

class ItemCopy {
  Collection collection;
  core.String collectionUuid;
  core.List<core.String> eligibleActions;
  ItemSummary itemSummary;
  core.String itemUuid;
  core.String status;
  core.String statusName;
  core.String uniqueId;
  core.bool userCanCheckout;
  core.bool userCanEdit;
  core.String uuid;

  ItemCopy();

  ItemCopy.fromJson(core.Map _json) {
    if (_json.containsKey("collection")) {
      collection = new Collection.fromJson(_json["collection"]);
    }
    if (_json.containsKey("collectionUuid")) {
      collectionUuid = _json["collectionUuid"];
    }
    if (_json.containsKey("eligibleActions")) {
      eligibleActions = _json["eligibleActions"];
    }
    if (_json.containsKey("itemSummary")) {
      itemSummary = new ItemSummary.fromJson(_json["itemSummary"]);
    }
    if (_json.containsKey("itemUuid")) {
      itemUuid = _json["itemUuid"];
    }
    if (_json.containsKey("status")) {
      status = _json["status"];
    }
    if (_json.containsKey("statusName")) {
      statusName = _json["statusName"];
    }
    if (_json.containsKey("uniqueId")) {
      uniqueId = _json["uniqueId"];
    }
    if (_json.containsKey("userCanCheckout")) {
      userCanCheckout = _json["userCanCheckout"];
    }
    if (_json.containsKey("userCanEdit")) {
      userCanEdit = _json["userCanEdit"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (collection != null) {
      _json["collection"] = (collection).toJson();
    }
    if (collectionUuid != null) {
      _json["collectionUuid"] = collectionUuid;
    }
    if (eligibleActions != null) {
      _json["eligibleActions"] = eligibleActions;
    }
    if (itemSummary != null) {
      _json["itemSummary"] = (itemSummary).toJson();
    }
    if (itemUuid != null) {
      _json["itemUuid"] = itemUuid;
    }
    if (status != null) {
      _json["status"] = status;
    }
    if (statusName != null) {
      _json["statusName"] = statusName;
    }
    if (uniqueId != null) {
      _json["uniqueId"] = uniqueId;
    }
    if (userCanCheckout != null) {
      _json["userCanCheckout"] = userCanCheckout;
    }
    if (userCanEdit != null) {
      _json["userCanEdit"] = userCanEdit;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class ItemSummary {
  core.String name;
  core.String thumbnail;
  core.String typeUuid;
  core.String uuid;

  ItemSummary();

  ItemSummary.fromJson(core.Map _json) {
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("thumbnail")) {
      thumbnail = _json["thumbnail"];
    }
    if (_json.containsKey("typeUuid")) {
      typeUuid = _json["typeUuid"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (name != null) {
      _json["name"] = name;
    }
    if (thumbnail != null) {
      _json["thumbnail"] = thumbnail;
    }
    if (typeUuid != null) {
      _json["typeUuid"] = typeUuid;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class ItemType {
  core.List<core.String> fieldUuids;
  core.List<Field> fields;
  core.String name;
  core.String readableId;
  core.String uuid;

  ItemType();

  ItemType.fromJson(core.Map _json) {
    if (_json.containsKey("fieldUuids")) {
      fieldUuids = _json["fieldUuids"];
    }
    if (_json.containsKey("fields")) {
      fields = _json["fields"].map((value) => new Field.fromJson(value)).toList();
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (fieldUuids != null) {
      _json["fieldUuids"] = fieldUuids;
    }
    if (fields != null) {
      _json["fields"] = fields.map((value) => (value).toJson()).toList();
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}

class ListOfCollection
    extends collection_1.ListBase<Collection> {
  final core.List<Collection> _inner;

  ListOfCollection() : _inner = [];

  ListOfCollection.fromJson(core.List json)
      : _inner = json.map((value) => new Collection.fromJson(value)).toList();

  core.List toJson() {
    return _inner.map((value) => (value).toJson()).toList();
  }

  Collection operator [](core.int key) => _inner[key];

  void operator []=(core.int key, Collection value) {
    _inner[key] = value;
  }

  core.int get length => _inner.length;

  void set length(core.int newLength) {
    _inner.length = newLength;
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

class MediaMessage {
  core.List<core.int> bytes;
  core.String cacheControl;
  core.String contentEncoding;
  core.String contentLanguage;
  core.String contentType;
  core.String md5Hash;
  core.Map<core.String, core.String> metadata;
  core.DateTime updated;

  MediaMessage();

  MediaMessage.fromJson(core.Map _json) {
    if (_json.containsKey("bytes")) {
      bytes = _json["bytes"];
    }
    if (_json.containsKey("cacheControl")) {
      cacheControl = _json["cacheControl"];
    }
    if (_json.containsKey("contentEncoding")) {
      contentEncoding = _json["contentEncoding"];
    }
    if (_json.containsKey("contentLanguage")) {
      contentLanguage = _json["contentLanguage"];
    }
    if (_json.containsKey("contentType")) {
      contentType = _json["contentType"];
    }
    if (_json.containsKey("md5Hash")) {
      md5Hash = _json["md5Hash"];
    }
    if (_json.containsKey("metadata")) {
      metadata = _json["metadata"];
    }
    if (_json.containsKey("updated")) {
      updated = core.DateTime.parse(_json["updated"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (bytes != null) {
      _json["bytes"] = bytes;
    }
    if (cacheControl != null) {
      _json["cacheControl"] = cacheControl;
    }
    if (contentEncoding != null) {
      _json["contentEncoding"] = contentEncoding;
    }
    if (contentLanguage != null) {
      _json["contentLanguage"] = contentLanguage;
    }
    if (contentType != null) {
      _json["contentType"] = contentType;
    }
    if (md5Hash != null) {
      _json["md5Hash"] = md5Hash;
    }
    if (metadata != null) {
      _json["metadata"] = metadata;
    }
    if (updated != null) {
      _json["updated"] = (updated).toIso8601String();
    }
    return _json;
  }
}

class PaginatedResponse {
  core.List<ItemSummary> items;
  core.int page;
  core.int pageCount;
  core.int startIndex;
  core.int totalCount;
  core.int totalPages;

  PaginatedResponse();

  PaginatedResponse.fromJson(core.Map _json) {
    if (_json.containsKey("items")) {
      items = _json["items"].map((value) => new ItemSummary.fromJson(value)).toList();
    }
    if (_json.containsKey("page")) {
      page = _json["page"];
    }
    if (_json.containsKey("pageCount")) {
      pageCount = _json["pageCount"];
    }
    if (_json.containsKey("startIndex")) {
      startIndex = _json["startIndex"];
    }
    if (_json.containsKey("totalCount")) {
      totalCount = _json["totalCount"];
    }
    if (_json.containsKey("totalPages")) {
      totalPages = _json["totalPages"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (items != null) {
      _json["items"] = items.map((value) => (value).toJson()).toList();
    }
    if (page != null) {
      _json["page"] = page;
    }
    if (pageCount != null) {
      _json["pageCount"] = pageCount;
    }
    if (startIndex != null) {
      _json["startIndex"] = startIndex;
    }
    if (totalCount != null) {
      _json["totalCount"] = totalCount;
    }
    if (totalPages != null) {
      _json["totalPages"] = totalPages;
    }
    return _json;
  }
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

class SetupRequest {
  core.String adminPassword;
  core.String adminUser;

  SetupRequest();

  SetupRequest.fromJson(core.Map _json) {
    if (_json.containsKey("adminPassword")) {
      adminPassword = _json["adminPassword"];
    }
    if (_json.containsKey("adminUser")) {
      adminUser = _json["adminUser"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (adminPassword != null) {
      _json["adminPassword"] = adminPassword;
    }
    if (adminUser != null) {
      _json["adminUser"] = adminUser;
    }
    return _json;
  }
}

class SetupResponse {
  core.bool adminUser;

  SetupResponse();

  SetupResponse.fromJson(core.Map _json) {
    if (_json.containsKey("adminUser")) {
      adminUser = _json["adminUser"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (adminUser != null) {
      _json["adminUser"] = adminUser;
    }
    return _json;
  }
}

class TransferRequest {
  core.List<core.String> itemCopyUuids;
  core.String targetCollectionUuid;

  TransferRequest();

  TransferRequest.fromJson(core.Map _json) {
    if (_json.containsKey("itemCopyUuids")) {
      itemCopyUuids = _json["itemCopyUuids"];
    }
    if (_json.containsKey("targetCollectionUuid")) {
      targetCollectionUuid = _json["targetCollectionUuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (itemCopyUuids != null) {
      _json["itemCopyUuids"] = itemCopyUuids;
    }
    if (targetCollectionUuid != null) {
      _json["targetCollectionUuid"] = targetCollectionUuid;
    }
    return _json;
  }
}

class UpdateItemRequest {
  core.List<MediaMessage> files;
  Item item;

  UpdateItemRequest();

  UpdateItemRequest.fromJson(core.Map _json) {
    if (_json.containsKey("files")) {
      files = _json["files"].map((value) => new MediaMessage.fromJson(value)).toList();
    }
    if (_json.containsKey("item")) {
      item = new Item.fromJson(_json["item"]);
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (files != null) {
      _json["files"] = files.map((value) => (value).toJson()).toList();
    }
    if (item != null) {
      _json["item"] = (item).toJson();
    }
    return _json;
  }
}

class User {
  core.String email;
  core.String name;
  core.String password;
  core.String readableId;
  core.String type;
  core.String uuid;

  User();

  User.fromJson(core.Map _json) {
    if (_json.containsKey("email")) {
      email = _json["email"];
    }
    if (_json.containsKey("name")) {
      name = _json["name"];
    }
    if (_json.containsKey("password")) {
      password = _json["password"];
    }
    if (_json.containsKey("readableId")) {
      readableId = _json["readableId"];
    }
    if (_json.containsKey("type")) {
      type = _json["type"];
    }
    if (_json.containsKey("uuid")) {
      uuid = _json["uuid"];
    }
  }

  core.Map toJson() {
    var _json = new core.Map();
    if (email != null) {
      _json["email"] = email;
    }
    if (name != null) {
      _json["name"] = name;
    }
    if (password != null) {
      _json["password"] = password;
    }
    if (readableId != null) {
      _json["readableId"] = readableId;
    }
    if (type != null) {
      _json["type"] = type;
    }
    if (uuid != null) {
      _json["uuid"] = uuid;
    }
    return _json;
  }
}
