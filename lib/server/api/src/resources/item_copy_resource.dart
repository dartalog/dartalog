part of api;

class ItemCopyResource extends AResource {
  static final Logger _log = new Logger('ItemCopyResource');
  static const _API_PATH = API_ITEMS_PATH;

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${_API_PATH}/{itemId}/${API_COPIES_PATH}/')
  Future<IdResponse> create(String itemId, ItemCopy itemCopy) =>
      _catchExceptions(_create(itemId, itemCopy));
  Future<IdResponse> _create(String itemId, ItemCopy itemCopy) async {
    String output = await model.items.copies.create(itemId,itemCopy);
    return new IdResponse.fromId(
        output, _generateCopyRedirect(itemId, itemCopy.copy));
  }

  @ApiMethod(path: '${_API_PATH}/{itemId}/${API_COPIES_PATH}/')
  Future<List<ItemCopy>> getAllForItem(String itemId) =>
      _catchExceptions(model.items.copies.getAllForItem(itemId));


  @ApiMethod(
      method: 'PUT', path: '${_API_PATH}/{itemId}/${API_COPIES_PATH}/{copy}/')
  Future<IdResponse> update(String itemId, int copy, ItemCopy itemCopy) =>
      _catchExceptions(_update(itemId, copy, itemCopy));
  Future<IdResponse> _update(String itemId, int copy, ItemCopy itemCopy) async {
    String output = await model.items.copies.update(itemId, copy,itemCopy);
    return new IdResponse.fromId(
        output, _generateCopyRedirect(itemId, itemCopy.copy));
  }

  @ApiMethod(path: '${_API_PATH}/{itemId}/${API_COPIES_PATH}/{copy}/')
  Future<ItemCopy> get(String itemId, int copy) =>
      _catchExceptions(model.items.copies.get(itemId, copy));


  @ApiMethod(
      method: 'PUT', path: '${_API_PATH}/{itemId}/${API_COPIES_PATH}/{copy}/action/')
  Future<VoidMessage> performAction(String itemId, int copy, ItemActionRequest actionRequest) =>
      _catchExceptions(_performAction(itemId, copy, actionRequest));
  Future<VoidMessage> _performAction(String itemId, int copy, ItemActionRequest actionRequest) async {
    //await model.items.copies.performAction(itemId, copy, actionRequest.action, actionRequest.actionerUserId);
    throw new Exception("Not Implemented");
    return new VoidMessage();
  }

  @ApiMethod(
      method: 'PUT', path: '${_API_PATH}/copies/bulk_action/')
  Future<VoidMessage> performBulkAction(BulkItemActionRequest actionRequest) =>
      _catchExceptions(_performBulkAction(actionRequest));
  Future<VoidMessage> _performBulkAction(BulkItemActionRequest actionRequest) async {
    await model.items.copies.performBulkAction(actionRequest.itemCopies, actionRequest.action, actionRequest.actionerUserId);
    return new VoidMessage();
  }

  String _generateCopyRedirect(String itemId, int copy) =>
      "${_generateRedirect(itemId)}/${API_COPIES_PATH}/${copy}";

}
