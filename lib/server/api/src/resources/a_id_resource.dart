part of api;

abstract class AIdResource<T extends AIdData> extends AResource {
  model.AIdNameBasedModel<T> get idModel;

  Future<IdResponse> create(T t);
  Future<IdResponse> _createWithCatch(T t) => _catchExceptionsAwait(() async {
        String output = await idModel.create(t);
        return new IdResponse.fromId(output, this._generateRedirect(output));
      });

  Future<VoidMessage> delete(String id);
  Future<VoidMessage> _deleteWithCatch(String id) =>
      _catchExceptionsAwait(() async {
        await idModel.delete(id);
        return new VoidMessage();
      });

  Future<List<IdNamePair>> getAllIdsAndNames();
  Future<List<IdNamePair>> _getAllIdsAndNamesWithCatch() async =>
      _catchExceptionsAwait(() => idModel.getAllIdsAndNames());

  //Future<PaginatedResponse<IdNamePair>> getPaginatedIdsAndNames({int offset: 0});
//  Future<PaginatedResponse<IdNamePair>> _getPaginatedIdsAndNamesWithCatch(
//      {int offset: 0}) async =>
//      _catchExceptionsAwait(() async =>
//      new PaginatedResponse<IdNamePair>.fromPaginatedData(
//          await idModel.getAllIdsAndNames()));

  Future<T> getById(String id);
  Future<T> _getByIdWithCatch(String id) =>
      _catchExceptionsAwait(() async => idModel.getById(id));

  Future<IdResponse> update(String id, T t);
  Future<IdResponse> _updateWithCatch(String id, T t) =>
      _catchExceptionsAwait(() async {
        String output = await idModel.update(id, t);
        return new IdResponse.fromId(output, this._generateRedirect(output));
      });
}
