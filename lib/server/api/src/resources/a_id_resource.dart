part of api;

abstract class AIdResource<T extends AIdData> extends AResource {
  model.AIdModel<T> get idModel;

  Future<IdResponse> create(T t);
  Future<IdResponse> _create(T t) => _catchExceptions(_createInternal(t));
  Future<IdResponse> _createInternal(T t) async {
    await t.validate(true);
    String output = await idModel.write(t);
    return new IdResponse.fromId(output, this._generateRedirect(output));
  }

  Future<VoidMessage> delete(String id);
  Future<VoidMessage> _delete(String id) =>
      _catchExceptions(_deleteInternal(id));
  Future<VoidMessage> _deleteInternal(String id) async {
    await idModel.delete(id);
    return new VoidMessage();
  }

  Future<List<IdNamePairResponse>> getAllIdsAndNames();
  Future<List<IdNamePairResponse>> _getAllIdsAndNames() =>
      _catchExceptions(_getAllIdsAndNamesInternal());
  Future<List<IdNamePairResponse>> _getAllIdsAndNamesInternal() =>
      idModel.getAllIdsAndNames();

  Future<T> getById(String id);
  Future<T> _getById(String id) => _catchExceptions(_getByIdInternal(id));
  Future<T> _getByIdInternal(String id) async {
    if(authenticatedContext()==null)
      throw new Exception();

    T output = await idModel.getById(id);
    if (output == null)
      throw new NotFoundError("ID '${id}' not found");

    return output;
  }

  Future<IdResponse> update(String id, T t);
  Future<IdResponse> _update(String id, T t) =>
      _catchExceptions(_updateInternal(id, t));
  Future<IdResponse> _updateInternal(String id, T t) async {
    await t.validate(id != t._id);
    String output = await idModel.write(t, id);
    return new IdResponse.fromId(output, this._generateRedirect(output));
  }
}
