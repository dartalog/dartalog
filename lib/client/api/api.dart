import 'package:dartalog/global.dart';

import '../client.dart';
import 'src/api_http_client.dart';
import 'src/item.dart';

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart'
    show DetailedApiRequestError, ApiRequestErrorDetail;
export 'package:dartalog/global.dart' show ListOfIdNamePair;

export 'src/item.dart'
    show
        ItemCopy,
        ItemCopyId,
        BulkItemActionRequest,
        ListOfIdNamePair,
        ImportResult,
        SearchResults,
        SearchResult,
        ItemType,
        CreateItemRequest,
        Item,
        IdNamePair,
        Field,
        PaginatedResponse,
        Collection,
        User,
        MediaMessage,
        UpdateItemRequest,
        TransferRequest,
        IdResponse;

ItemApi _item;
ItemApi get item {
  if (_item == null) {
    _item = new ItemApi(new ApiHttpClient(),
        rootUrl: getServerRoot(), servicePath: itemApiPath);
  }
  return _item;
}
