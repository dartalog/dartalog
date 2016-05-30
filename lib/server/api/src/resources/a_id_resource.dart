part of api;

abstract class AIdResource<T extends AIdData> extends AResource {
  model.AIdNameBasedModel<T> get idModel;

  Future<IdResponse> create(T t);
  Future<IdResponse> _createWithCatch(T t) => _catchExceptions(_createInternal(t));
  Future<IdResponse> _createInternal(T t) async {
    String output = await idModel.create(t);
    return new IdResponse.fromId(output, this._generateRedirect(output));
 }


  Future<VoidMessage> delete(String id);
  Future<VoidMessage> _deleteWithCatch(String id) =>
      _catchExceptions(_deleteInternal(id));
  Future<VoidMessage> _deleteInternal(String id) async {
    await idModel.delete(id);
    return new VoidMessage();
  }

  Future<List<IdNamePair>> getAllIdsAndNames();
  Future<List<IdNamePair>> _getAllIdsAndNamesWithCatch() =>
      _catchExceptions(_getAllIdsAndNamesInternal());
  Future<List<IdNamePair>> _getAllIdsAndNamesInternal() =>
      idModel.getAllIdsAndNames();

  Future<T> getById(String id);
  Future<T> _getByIdWithCatch(String id) => _catchExceptions(_getByIdInternal(id));
  Future<T> _getByIdInternal(String id)  => idModel.getById(id);

  Future<IdResponse> update(String id, T t);
  Future<IdResponse> _updateWithCatch(String id, T t) =>
      _catchExceptions(_updateInternal(id, t));
  Future<IdResponse> _updateInternal(String id, T t) async {
    String output = await idModel.update(id, t);
    return new IdResponse.fromId(output, this._generateRedirect(output));
  }
}
